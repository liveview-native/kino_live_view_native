# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :kino_live_view_native_web,
  generators: [context_app: :kino_live_view_native]

# Configures the endpoint
config :kino_live_view_native_web, KinoLiveViewNativeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: KinoLiveViewNativeWeb.ErrorHTML, json: KinoLiveViewNativeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KinoLiveViewNative.PubSub,
  live_view: [signing_salt: "MNtzIgwp"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  kino_live_view_native_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/kino_live_view_native_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  kino_live_view_native_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/kino_live_view_native_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :live_view_native, plugins: [LiveViewNative.SwiftUI]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
