defmodule ServerWeb.Styles.SwiftUI do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    foregroundStyle(.red)
  end
  """
end
