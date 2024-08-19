defmodule Server.CodeReloader do
  def reload!(_, _) do
    # Calling `Mix.Project.app_path()` when Phoenix from Livebook produces the following error:
    # Cannot access build without an application name, please ensure you are in a directory with a mix.exs file and it defines an :app name under the project configuration
    # This function is called by `Mix.Project.consolidation_paths/1` when recompiling because `Mix.Project.umbrella?/1` returns false.
    # This custom code reloader hides the error, though it will still print in the Livebook console, but not in Livebook code cells.
    :ok
  end
end
