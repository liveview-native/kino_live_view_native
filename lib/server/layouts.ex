defmodule Server.Layouts do
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.HTML.Tag

  def root_layout(assigns) do
    ~H"""
      <html>
      <head>
         <meta name="csrf-token" content={csrf_token_value()}>
      </head>
      <body>
        <%= @inner_content %>
      </body>
      </html>
    """
  end
end
