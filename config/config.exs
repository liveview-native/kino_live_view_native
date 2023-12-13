import Config

config :live_view_native,
  plugins: [LiveViewNative.SwiftUI]

config :live_view_native_stylesheet,
  parsers: [
    swiftui: LiveViewNative.SwiftUI.RulesParser
  ]
