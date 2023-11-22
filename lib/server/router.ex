defmodule Server.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :images do
    plug Plug.Static,
      at: "/images",
      from: {:kino_live_view_native, "priv/static"}
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_root_layout, html: {Server.Layouts, :root_layout}
  end

  scope "/images" do
    pipe_through :images
  end

  scope "/" do
    pipe_through :browser

    KinoLiveViewNative.get_routes()
    |> Enum.map(fn %{path: path, module: module, action: action} ->
      live(path, module, action)
    end)
  end
end
