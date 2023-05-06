defmodule KinoLiveViewNative.Server.LiveReloader.Channel do
  use Phoenix.Channel

  def join("phoenix:live_reload", _msg, socket) do
    {:ok, _} = Application.ensure_all_started(:phoenix_live_reload)

    Phoenix.PubSub.subscribe(KinoLiveViewNative.Server.PubSub, "reloader")

    {:ok, socket}
  end

  def handle_info(:trigger, socket) do
    push(socket, "assets_change", %{asset_type: ""})

    {:noreply, socket}
  end
end
