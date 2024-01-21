defmodule Server.CoreComponents do
  @moduledoc """
  Phoenix typically defines a wide variety of core components.
  We currently omit these components.

  However, we do need the translate_error function in the LiveView Native Guide on forms.
  """
  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Server.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Server.Gettext, "errors", msg, opts)
    end
  end
end
