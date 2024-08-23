defmodule Server.CodeReloader do
  require Logger

  def reload!(_, _) do
    # This transaction ensures that this function is only called once during the code reload.
    # This change was due to an error where the web app.js would not load properly and web event handlers were broken
    :global.trans({:resource_id, :lock_requester_id}, fn ->
      try do
        # reloads the stylesheet and any other files that need to recompile.
        Mix.in_install_project(fn ->
          # Fixed in future Hex, but needed for now
          _ = Application.ensure_all_started(:hex)
          Mix.Task.rerun("deps.compile", ["kino_live_view_native"])
          Mix.Task.clear()
          :ok
        end)
      rescue
        error ->
          # Occasionally, `Mix.in_install_project/1` throws `{:error, "nofile"}.
          # It is an intermittent issue that this helps stabilize.
          Logger.error("""
          Rescued the following error in the Mix.in_install_project/1 function.

          #{inspect(error)}

          If code reloading or stylesheets break, consider restarting the Livebook or re-evaluating the LVN code cell.
          """
          )
      catch
        error ->
          Logger.error(inspect(error))
      end
    end)
  end
end
