defmodule Server.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:put_root_layout, html: {Server.Layouts, :root_layout})
  end

  scope "/", Server do
    pipe_through(:browser)

    live("/", HomeLive, :index)
  end
end
