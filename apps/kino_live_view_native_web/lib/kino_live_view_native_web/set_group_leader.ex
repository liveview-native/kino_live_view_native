defmodule KinoLiveViewNativeWeb.SetGroupLeader do
  @moduledoc """
  Set the group leader for the current process to the one specified in the
  kino Livebook configuration. This allows IO.inspect logs to be viewed in Livebook
  instead of the terminal.
  """

  def on_mount(_, _params, _session, socket) do
    Process.group_leader(self(), Application.get_env(:kino, :group_leader) || Process.group_leader())
    {:cont, socket}
  end
end
