defmodule Server.Livebook do
  defmacro defmodule(alias, do_block) do
    module_name =
      alias
      |> Macro.to_string()
      |> then(&("Elixir." <> &1))
      |> String.to_atom()

    # Avoids module already defined error
    Livebook.Runtime.Evaluator.delete_module(module_name)

    quote do
      Kernel.defmodule(unquote(alias), unquote(do_block))
    end
  end
end
