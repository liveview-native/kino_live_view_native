defmodule ServerWeb.Layouts do
  use ServerWeb, :html
  use LiveViewNative.Layouts

  embed_templates "layouts/*.html"
end
