defmodule ServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :server

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_server_key",
    signing_salt: "JSgdVVL6",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    # Swap the socket when running mix phx.server instead of Livebook
    # socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    socket "/phoenix/live_reload/socket", ServerWeb.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug LiveViewNative.LiveReloader
    # Swap the code reloader when running through mix phx.server instead of Livebook
    # plug Phoenix.CodeReloader
    plug Phoenix.CodeReloader, reloader: &Server.CodeReloader.reload!/2
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :server_web,
    gzip: false,
    only: ServerWeb.static_paths()

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  # Added for 0.3.0
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug ServerWeb.Router
end
