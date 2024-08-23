defmodule Server.Livebook do
  defmacro defmodule(alias, do_block) do
    module_name =
      alias
      |> Macro.to_string()
      |> then(&("Elixir." <> &1))
      |> String.to_atom()

    # Avoids module already defined error
    # We can ignore the compilation warning because Livebook will be available when compiling inside of a Livebook as a mix dependency.
    Livebook.Runtime.Evaluator.delete_module(module_name)

    quote do
      Kernel.defmodule(unquote(alias), unquote(do_block))
    end
  end
end
