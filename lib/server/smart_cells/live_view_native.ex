defmodule Server.SmartCells.LiveViewNative do
  require IEx.Helpers
  require Logger

  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "LiveView Native: LiveView"

  @registry_key :liveviews

  @impl true
  def init(attrs, ctx) do
    {:ok, [{ip, _, _} | _]} = :inet.getif()
    ip_address = ip |> Tuple.to_list() |> Enum.map(&to_string/1) |> Enum.join(".")

    {:ok,
     ctx
     |> assign(path: attrs["path"] || "/")
     |> assign(
       qr:
         QRCode.create("http://#{ip_address}:4000")
         |> QRCode.render(:svg, %QRCode.Render.SvgSettings{background_color: "#ecf0ff"})
         |> QRCode.to_base64()
         |> elem(1)
     ),
     editor: [
       attribute: "code",
       language: "elixir",
       default_source: default_source()
     ]}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{path: ctx.assigns.path, qr: ctx.assigns.qr}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{
      "path" => ctx.assigns.path,
      "qr" => ctx.assigns.qr
    }
  end

  @impl true
  def to_source(attrs) do
    [
      # Use our defmodule definition
      """
      require Server.Livebook
      import Server.Livebook
      import Kernel, except: [defmodule: 2]
      """,
      attrs["code"],
      "|> #{register_module_source(attrs)}",
      # Restore the existing definition
      """
      import Server.Livebook, only: []
      import Kernel
      :ok
      """
    ]
  end

  def register_module_source(attrs) do
    quote do
      unquote(__MODULE__).register(unquote(attrs["path"]))
    end
    |> Kino.SmartCell.quoted_to_string()
  end

  @impl true
  def handle_event("update_" <> variable_name, value, ctx) do
    variable = String.to_existing_atom(variable_name)
    ctx = assign(ctx, [{variable, value}])

    broadcast_event(
      ctx,
      "update_" <> variable_name,
      ctx.assigns[variable]
    )

    {:noreply, ctx}
  end

  def get_routes() do
    Application.get_env(:server, @registry_key, [])
  end

  defp put_routes(routes) do
    Application.put_env(:server, @registry_key, routes)
  end

  def register({:module, module, _, _}, path) do
    new_route = %{path: path, module: module}

    get_routes()
    # Remove existing route with the same path
    |> Enum.reject(fn r -> r.path == path end)
    |> Enum.filter(fn r -> is_valid_liveview(r.module) end)
    |> Kernel.++([new_route])
    |> put_routes()

    # Reloading routes must occur before the LV evaluates in Livebook.
    # Otherwise the LV will not be available for previously defined routes when changing the LV name.
    IEx.Helpers.r(ServerWeb.Router)
    Phoenix.PubSub.broadcast!(Server.PubSub, "reloader", :trigger)
  end

  def default_source() do
    ~s[defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, \[:render_component, format: :swiftui\]

  def render(assigns) do
    ~LVN"""
    <Text>Hello, from LiveView Native!</Text>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""
end]
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      ctx.importCSS("main.css");
      ctx.importCSS("https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap");

      root.innerHTML = `
        <div class="app">
          <label class="label">LiveView route:</label>
          <input class="input" type="text" name="path" />
          #{if Application.get_env(:kino_live_view_native, :qr_enabled, false) do
      """
      <div class="qr-container">
        <div class="info">
          <span class="title">Connect a client</span>
          <span class="subtitle">Scan the code with LiveView Native Go to connect.</span>
        </div>
        <img src="data:image/svg+xml; base64, ${payload.qr}" class="qr" />
      </div>
      """
    else
      ""
    end}
        </div>
      `;

      const sync = (id) => {
          const variableEl = ctx.root.querySelector(`[name="${id}"]`);
          variableEl.value = payload[id];

          variableEl.addEventListener("change", (event) => {
            ctx.pushEvent(`update_${id}`, event.target.value);
          });

          ctx.handleEvent(`update_${id}`, (variable) => {
            variableEl.value = variable;
          });
      }

      sync("path")

      ctx.handleSync(() => {
          // Synchronously invokes change listeners
          document.activeElement &&
            document.activeElement.dispatchEvent(new Event("change"));
      });
    }
    """
  end

  asset "main.css" do
    """
    .app {
      font-family: "Inter";
      display: flex;
      align-items: center;
      gap: 16px;
      background-color: #ecf0ff;
      padding: 8px 16px;
      border: solid 1px #cad5e0;
      border-radius: 0.5rem 0.5rem 0 0;
    }

    .label {
      font-size: 0.875rem;
      font-weight: 500;
      color: #445668;
    }

    .input {
      padding: 8px 12px;
      background-color: #f8f8afc;
      font-size: 0.875rem;
      border: 1px solid #e1e8f0;
      border-radius: 0.5rem;
      color: #445668;
      min-width: 150px;
    }

    .input:focus {
      border: 1px solid #61758a;
      outline: none;
    }

    .qr-container {
      display: flex;
      flex-direction: row;
      gap: 8px;
      flex-grow: 1;
      justify-content: flex-end;
    }

    .qr-container .qr {
      height: 50px;
    }

    .qr-container .info {
      display: flex;
      flex-direction: column;
      font-size: 0.875rem;
      color: #445668;
      max-width: 200px;
      text-align: right;
    }

    .qr-container .info .title {
      font-weight: 500;
    }
    """
  end

  defp is_valid_liveview(module) do
    if Kernel.function_exported?(module, :__live__, 0) do
      true
    else
      Logger.error("Module #{inspect(module)} is not a valid LiveView.")
      false
    end
  end
end
