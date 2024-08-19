defmodule ServerWeb.HelloLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <p phx-click="clicked">Hello from LiveView!</p>
    """
  end

  @impl true
  def handle_event("clicked", _params, socket) do
    IO.inspect("CLICKED")
    {:noreply, socket}
  end
end
