defmodule Server.CodeReloader do
  def reload!(_, _) do
    Mix.in_install_project(fn ->
      # Fixed in future Hex, but needed for now
      _ = Application.ensure_all_started(:hex)
      Mix.Task.rerun("deps.compile", ["kino_live_view_native"])
      Mix.Task.clear()
    end)
  end
end
