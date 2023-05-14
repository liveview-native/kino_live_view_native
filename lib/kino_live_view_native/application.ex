defmodule KinoLiveViewNative.Application do
  use Application

  def start(_type, _args) do
    Kino.SmartCell.register(KinoLiveViewNative)

    children = []
    opts = [strategy: :one_for_one, name: KinoLiveViewNative.Supervisor]
    Supervisor.start_link(children, opts)

  end
end
