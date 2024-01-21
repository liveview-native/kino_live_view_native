defmodule KinoLiveViewNativeTest do
  use ExUnit.Case

  defmodule KinoLiveViewNativeTest.ExampleLive do
    use Phoenix.LiveView
    use LiveViewNative.LiveView

    @impl true
    def render(%{format: :swiftui} = assigns) do
      ~SWIFTUI"""
      <Text>Hello Native</Text>
      """
    end

    def render(assigns) do
      ~H"""
      <p>Hello Web</p>
      """
    end
  end

  test "start server and register a LiveView" do
    assert {:ok, pid} = KinoLiveViewNative.start([])

    KinoLiveViewNative.register(
      {:module, KinoLiveViewNativeTest.ExampleLive, 0, 0},
      "/",
      ":index"
    )

    assert Req.get!("http://localhost:4000").body =~ "Hello Web"
    assert Req.get!("http://localhost:4000?_lvn[format]=swiftui").body =~ "Hello Native"
  end
end
