defmodule ServerWeb.SetGroupLeader do
  require Logger

  def on_mount(_, _params, _session, socket) do
    Process.group_leader(self(), Application.get_env(:kino, :group_leader))
    {:cont, socket}
  end
end
