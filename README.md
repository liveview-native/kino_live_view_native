# KinoLiveViewNative

Use the following within a Livebook notebook:

## Setup

```elixir
Mix.install([
  {:kino_live_view_native, github: "liveview-native/kino_live_view_native", env: :dev}
])

KinoLiveViewNative.start(app_name: "LiveView Native", port: 5001)
```

## Code block

```elixir
defmodule Server.HomeLive do
  use Phoenix.LiveView, layout: {__MODULE__, :layout}
  use LiveViewNative.LiveView

  def layout(assigns) do
    ~H"""
      <%= @inner_content %>
    """
  end

  @impl true
  def render(%{platform_id: :swiftui} = assigns) do
    ~Z"""
    <Text modifiers={@native |> foreground_style(primary: {:color, :mint})}>
      Hello from LiveView Native!
    </Text>
    """swiftui
  end

  def render(assigns) do
    ~H"""
    <div>Hello from LiveView!!</div>
    """
  end
end
```
