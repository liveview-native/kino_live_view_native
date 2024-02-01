defmodule ServerWeb.HelloLive do
  use ServerWeb, :live_view

  def mount(params, session, socket) do
   {:ok, socket}
  end

  def render(assigns = %{format: :swiftui}) do
    ~SWIFTUI"""
    <Text>Hello Native</Text>
    """
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Hello Web!</h1>
    </div>
    """
  end
end
