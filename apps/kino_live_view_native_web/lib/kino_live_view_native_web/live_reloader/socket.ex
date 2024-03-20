defmodule KinoLiveViewNativeWeb.LiveReloader.Socket do
  use Phoenix.Socket, log: false

  channel("phoenix:live_reload", KinoLiveViewNativeWeb.LiveReloader.Channel)

  def connect(_params, socket), do: {:ok, socket}

  def id(_socket), do: nil
end
