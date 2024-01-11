defmodule Server.Router do
  require Logger
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :images do
    plug Plug.Static,
      at: "/images",
      from: {:kino_live_view_native, "priv/static"}
  end

  pipeline :browser do
    plug :accepts, ["html", "swiftui"]
    plug CustomPlug
    plug :fetch_query_params
    plug :put_root_layout, html: {Server.Layouts, :root}, swiftui: {Server.LayoutsSwiftUI, :root}
  end

  scope "/images" do
    pipe_through :images
    get "/*path", Server.ErrorController, :not_found
  end

  scope "/" do
    pipe_through :browser


    KinoLiveViewNative.get_routes()
    |> Enum.map(fn %{path: path, module: module, action: action} ->
      # Ensure module is a LiveView
      if Kernel.function_exported?(module, :__live__, 0) do
        live(path, module, action)
      else
        Logger.error("Module #{inspect(module)} is not a valid LiveView.")
      end
    end)
  end
end
