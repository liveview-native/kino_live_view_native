defmodule KinoLiveViewNativeWeb.Layouts.SwiftUI do
  use KinoLiveViewNativeNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
