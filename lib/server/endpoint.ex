defmodule Server.Endpoint do
  use Phoenix.Endpoint, otp_app: :kino_live_view_native
  socket("/live", Phoenix.LiveView.Socket)
  socket("/phoenix/live_reload/socket", Server.LiveReloader.Socket)
  plug(Phoenix.LiveReloader)
  plug(Server.Router)
end
