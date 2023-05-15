defmodule Server.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:put_root_layout, html: {Server.Layouts, :root_layout})
  end

  scope "/" do
    pipe_through(:browser)

    KinoLiveViewNative.get_routes()
    |> Enum.map(fn %{path: path, module: module, action: action} ->
      live(path, module, action)
    end)
  end
end
