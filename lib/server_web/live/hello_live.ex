defmodule ServerWeb.HelloLive do
  use ServerWeb, :live_view
  use LiveViewNative.LiveView,
    formats: [:swiftui],
    layouts: [
      swiftui: {ServerWeb.Layouts.SwiftUI, :app}
    ]

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello from LiveView!</p>
    """
  end
end
