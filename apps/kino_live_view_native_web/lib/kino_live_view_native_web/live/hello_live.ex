defmodule KinoLiveViewNativeWeb.HelloLive do
  use KinoLiveViewNativeWeb, :live_view

  use LiveViewNative.LiveView,
    formats: [:swiftui],
    layouts: [
      swiftui: {KinoLiveViewNativeWeb.Layouts.SwiftUI, :app}
    ]

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello from LiveView!</p>
    """
  end
end
