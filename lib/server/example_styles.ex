defmodule Server.ExampleStyles do
  use LiveViewNative.Stylesheet, :swiftui

  ~SHEET"""
  "color-red" do
    foregroundStyle(.red)
  end
  """
end
