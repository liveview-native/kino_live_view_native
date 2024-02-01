defmodule Server.Livebook do
  defmacro defmodule(alias, do_block) do
    module_name =
      alias
      |> Macro.to_string()
      |> then(&("Elixir." <> &1))
      |> String.to_atom()

    if is_registered_live_view?(module_name) do
      IO.inspect("Replacing existing LiveView #{module_name}")
      Livebook.Runtime.Evaluator.delete_module(module_name)
    end

    quote do
      Kernel.defmodule(unquote(alias), unquote(do_block))
    end
  end

  defp is_registered_live_view?(module_name) do
    Server.SmartCells.LiveViewNative.get_routes()
    |> Enum.any?(&(&1.module == module_name))
  end
end
