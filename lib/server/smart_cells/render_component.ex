defmodule Server.SmartCells.RenderComponent do
  require IEx.Helpers
  require Logger

  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "LiveView Native: Render Component"

  @registry_key :liveviews

  @impl true
  def init(attrs, ctx) do
    {:ok,
     ctx,
     editor: [
       attribute: "code",
       language: "elixir",
       default_source: default_source()
     ]}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{}
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
      "|> #{register_module_source()}",
      # Restore the existing definition
      """
      import Server.Livebook, only: []
      import Kernel
      :ok
      """
    ]
  end

  def register_module_source() do
    quote do
      unquote(__MODULE__).register()
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

  def register({:module, module, _, _}) do
    live_view = to_string(module) |> String.split(".") |> List.delete("SwiftUI") |> Enum.join(".") |> String.to_atom()

    if is_valid_liveview(live_view) do
      Phoenix.PubSub.broadcast!(Server.PubSub, "reloader", :trigger)
    else
      raise "Missing #{live_view} module."
    end
  end

  def default_source() do
  ~s[defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, \[:render_component, format: :swiftui\]

  def render(assigns) do
    ~LVN"""
    <Text>Hello, from LiveView Native!</Text>
    """
  end
end]
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      ctx.importCSS("main.css");
      ctx.importCSS("https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap");

      root.innerHTML = `
        <div class="app">
          <label class="label">Render component</label>
        </div>
      `;
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
    """
  end

  defp is_valid_liveview(module) do
    if Kernel.function_exported?(module, :__live__, 0) do
      true
    else
      Logger.error("Module #{inspect(module)} is not a valid LiveView. Make sure to define the corresponding LiveView for this #{module} render component.")
      false
    end
  end
end
