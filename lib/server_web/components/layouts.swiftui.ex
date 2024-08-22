defmodule ServerWeb.Layouts.SwiftUI do
  use ServerNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
