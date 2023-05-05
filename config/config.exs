import Config

config :live_view_native,
  platforms: [
    LiveViewNativeSwiftUi.Platform
  ]

config :server, Server.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 5001],
  server: true,
  pubsub_server: Server.PubSub,
  live_view: [signing_salt: "aaaaaaaa"],
  secret_key_base: String.duplicate("a", 64),
  live_reload: [
    patterns: [
      ~r/#{__ENV__.file |> String.split("#") |> hd()}$/
    ]
  ]
