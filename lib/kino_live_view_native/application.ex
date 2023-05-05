defmodule KinoLiveViewNative.Application do
  use Application
  require Config

  def start(_type, _args) do
    config_path =
      __ENV__.file
      |> Path.dirname()
      |> Path.join("../../config/config.exs")
      |> Path.expand()

    Config.import_config(config_path)

    Kino.SmartCell.register(KinoLiveViewNative)

    Supervisor.start_link(
      [
        {Phoenix.PubSub, name: Server.PubSub},
        Server.Endpoint
      ],
      strategy: :one_for_one
    )
  end
end
