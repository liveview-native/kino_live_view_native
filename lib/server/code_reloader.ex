defmodule Server.CodeReloader do
  def reload!(_, _) do
    # This transaction ensures that this function is only called once during the code reload.
    # This change was due to an error where the web app.js would not load properly and web event handlers were broken
    :global.trans({:resource_id, :lock_requester_id}, fn ->
      Mix.in_install_project(fn ->
        # Fixed in future Hex, but needed for now
        _ = Application.ensure_all_started(:hex)
        Mix.Task.rerun("deps.compile", ["kino_live_view_native"])
        Mix.Task.clear()
      end)
    end)
  end
end
