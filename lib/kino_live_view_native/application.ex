defmodule KinoLiveViewNative.Application do
  use Application

  def start(_type, _args) do
    # config_path =
    #   __ENV__.file
    #   |> Path.dirname()
    #   |> Path.join("../../config/config.exs")
    #   |> Path.expand()

    Kino.SmartCell.register(KinoLiveViewNative)

    Supervisor.start_link(
      [
        {Phoenix.PubSub, name: KinoLiveViewNative.Server.PubSub},
        KinoLiveViewNative.Server.Endpoint
      ],
      strategy: :one_for_one
    )
  end
end
