# KinoLiveViewNative

Use the following within a Livebook notebook:

## Setup

```elixir
my_app_root = "../kino_live_view_native"

Mix.install(
  [
    {:kino_live_view_native, path: my_app_root}
  ],
  config_path: Path.join(my_app_root, "config/config.exs"),
  lockfile: Path.join(my_app_root, "mix.lock")
)

# Starts the server on port 4000
KinoLiveViewNative.start([port: 4000])
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
