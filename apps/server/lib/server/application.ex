defmodule Server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Server.PubSub}
      # Start a worker by calling: Server.Worker.start_link(arg)
      # {Server.Worker, arg}
    ]

    Kino.SmartCell.register(Server.SmartCells.LiveViewNative)
    Kino.SmartCell.register(Server.SmartCells.RenderComponent)

    Supervisor.start_link(children, strategy: :one_for_one, name: Server.Supervisor)
  end
end
