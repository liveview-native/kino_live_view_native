defmodule KinoLiveViewNative.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_live_view_native,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoLiveViewNative.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.11.3"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7"},
      {:phoenix_live_reload, "~> 1.4"},
      {:phoenix_live_view, "~> 0.20.1"},
      {:live_view_native_swift_ui, "~> 0.1.0"},
      {:live_view_native, github: "liveview-native/live_view_native"}
    ]
  end
end
