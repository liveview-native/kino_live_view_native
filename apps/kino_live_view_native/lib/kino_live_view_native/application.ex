defmodule KinoLiveViewNative.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster,
       query: Application.get_env(:kino_live_view_native, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KinoLiveViewNative.PubSub}
      # Start a worker by calling: KinoLiveViewNative.Worker.start_link(arg)
      # {KinoLiveViewNative.Worker, arg}
    ]

    Kino.SmartCell.register(KinoLiveViewNative.SmartCells.LiveViewNative)

    Supervisor.start_link(children, strategy: :one_for_one, name: KinoLiveViewNative.Supervisor)
  end
end
