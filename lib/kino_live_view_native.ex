defmodule KinoLiveViewNative do
  use Kino.SmartCell, name: "LiveView Native"

  def init(_attrs, ctx) do
    {:ok, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{"text" => ctx.assigns.text}
  end

  @impl true
  def to_source(attrs) do
    quote do
      IO.puts(unquote(attrs["text"]))
    end
    |> Kino.SmartCell.quoted_to_string()
  end

  def scan_eval_result(_server, _eval_result) do
    Phoenix.PubSub.broadcast!(Server.PubSub, "reloader", :trigger)
  end
end
