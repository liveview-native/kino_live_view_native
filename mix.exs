defmodule KinoLiveViewNative.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_live_view_native,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoLiveViewNative.Application, []},
      extra_applications: [:logger, :server]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.9.3"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.7.2", override: true},
      {:phoenix_live_view, "~> 0.18.2"},
      {:phoenix_live_reload, "~> 1.4.1", override: true},
      {:live_view_native, "~> 0.0.7"},
      {:live_view_native_swift_ui, "~> 0.0.7"}
    ]
  end
end
