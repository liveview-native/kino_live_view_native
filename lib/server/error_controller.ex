defmodule Server.ErrorController do
  use Phoenix.Controller

  def not_found(conn, _) do
    send_resp(conn, 404, "Not Found")
  end
end
