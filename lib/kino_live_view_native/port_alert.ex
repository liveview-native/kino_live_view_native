defmodule KinoLiveViewNative.PortAlert do
  use Kino.JS
  use Kino.JS.Live
  require Logger
  alias KinoLiveViewNative.PortChecker

  def check!(init_state) do
    if PortChecker.port_available?(init_state.port) do
      init_state.on_confirm.()
    else
      Kino.JS.Live.new(__MODULE__, init_state)
    end
  end

  @impl true
  def init(init_state, ctx) do
    {:ok, assign(ctx, init_state)}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, ctx.assigns.port, ctx}
  end

  @impl true
  def handle_event("stop_server", %{"accepted" => accepted}, ctx) do
    if accepted do
      PortChecker.kill_processes(ctx.assigns.port)
      ctx.assigns.on_confirm.()
    else
      Logger.error("Stop the server running on port #{ctx.assigns.port} to run this Livebook.")
      # allow time for the logger to print before killing the parent Livebook
      Process.sleep(100)

      # Kill the parent livebook to prevent further execution. We cannot use Kino.interrupt! because it does not work inside an event handler.
      Process.exit(ctx.assigns.liveview_pid, :kill)
    end

    {:noreply, ctx}
  end

  asset "main.js" do
    """
    export function init(ctx, port) {
      const accepted = confirm(`Port ${port} is in use. Do you want to stop the server to run this Livebook?`)
      ctx.pushEvent("stop_server", {accepted: accepted})
    }
    """
  end
end
