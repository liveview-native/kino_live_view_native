# This file is responsible for configuring LiveView Native.
# It is auto-generated when running `mix lvn.install`.
import Config

config :live_view_native,
  plugins: [
    LiveViewNative.SwiftUI
  ]

# LVN - Required, you must add the swiftui mimetype so
# Phoenix can respond to and respond with the correct content-type
config :mime, :types, %{
  "text/swiftui" => ["swiftui"]
}

# LVN - Required, you must configure LiveView Native Stylesheets
# on where class names shoudl be extracted from
config :live_view_native_stylesheet,
  content: [
    swiftui: [
      "lib/**/*swiftui*"
    ]
  ]

# LVN - Required, you must configure Phoenix to know how
# to encode for the swiftui format
config :phoenix_template, :format_encoders, swiftui: Phoenix.HTML.Engine

# LVN - Required, you must configure Phoenix so it knows
# how to compile LVN's neex templates
config :phoenix, :template_engines, neex: LiveViewNative.Engine
