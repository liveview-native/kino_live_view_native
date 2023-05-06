# KinoLiveViewNative

Use the following within a Livebook notebook:

## Setup

```elixir
Mix.install([
  {:kino_live_view_native, github: "liveview-native/kino_live_view_native", env: :dev}
],
config: [
    live_view_native: [
      {:platforms, [LiveViewNativeSwiftUi.Platform]},
      {LiveViewNativeSwiftUi.Platform, [app_name: "LiveView Native"]}
    ],
    kino_live_view_native: [
      {KinoLiveViewNative.Server.Endpoint,
       [
         http: [ip: {127, 0, 0, 1}, port: 5001],
         server: true,
         pubsub_server: KinoLiveViewNative.Server.PubSub,
         live_view: [signing_salt: "aaaaaaaa"],
         secret_key_base: String.duplicate("a", 64),
         live_reload: [
           patterns: [
             ~r/#{__ENV__.file |> String.split("#") |> hd()}$/
           ]
         ]
       ]}
    ]
  ])
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