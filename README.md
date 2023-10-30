# KinoLiveViewNative

Use the following within a Livebook notebook:

## Setup

```elixir
Mix.install(
  [
    {:kino_live_view_native, github: "liveview-native/kino_live_view_native"}
  ],
  config: [
    # This must be a compile time configuration for :live_view_native.
    live_view_native: [plugins: [LiveViewNativeSwiftUi]]
  ]
)

# Starts the server on port 4000
KinoLiveViewNative.start([])
```

## Code block

```elixir
defmodule Server.HomeLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def layout(assigns) do
    ~H"""
      <%= @inner_content %>
    """
  end

  @impl true
  def render(%{platform_id: :swiftui} = assigns) do
    ~SWIFTUI"""
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
