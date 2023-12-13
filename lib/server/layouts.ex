defmodule Server.Layouts do
  use Phoenix.Component

  import Phoenix.Controller,
    only: [get_csrf_token: 0, view_module: 1, view_template: 1]

  import Phoenix.HTML
  use LiveViewNative.Layouts


  embed_templates "layouts/*.html"
end
