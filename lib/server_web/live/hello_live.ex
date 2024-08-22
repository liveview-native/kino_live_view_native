defmodule ServerWeb.HelloLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  def render(assigns) do
    ~H"""
    <p>Hello World</p>
    """
  end
end
