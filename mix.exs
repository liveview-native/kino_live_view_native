defmodule KinoLiveViewNative.MixProject do
  use Mix.Project
  @version "0.2.0-rc.1"

  def project do
    [
      app: :kino_live_view_native,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/liveview-native/kino_live_view_native",
      docs: [
        source_ref: "v#{@version}",
        main: "example", # The main page in the docs
        logo: "notebooks/assets/logo.png",
        extras: ["notebooks/example.livemd"]
      ]
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
      {:phoenix_live_view, "0.20.1"},
      {:live_view_native_swiftui, "~> 0.2.0-rc.1"},
      {:live_view_native, "~> 0.2.0-rc.1"},
      {:req, "~> 0.4.8"},
      {:ex_doc, "~> 0.31.0", only: :dev, runtime: false},
    ]
  end
end
