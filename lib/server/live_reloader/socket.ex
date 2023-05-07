defmodule Server.LiveReloader.Socket do
  use Phoenix.Socket, log: false

  channel("phoenix:live_reload", Server.LiveReloader.Channel)

  def connect(_params, socket), do: {:ok, socket}

  def id(_socket), do: nil
end
