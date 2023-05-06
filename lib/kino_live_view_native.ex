defmodule KinoLiveViewNative do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "LiveView Native"

  @impl true
  def init(attrs, ctx) do
    {:ok, ctx,
     editor: [
       attribute: "code",
       language: "elixir",
       default_source: ~s[
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
]
     ]}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{}
  end

  @impl true
  def to_source(attrs) do
    attrs["code"]
  end

  def scan_eval_result(_server, _eval_result) do
    Phoenix.PubSub.broadcast!(Server.PubSub, "reloader", :trigger)
  end
end
