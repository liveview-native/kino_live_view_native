defmodule Server.AttributeParsers.Style do
  def parse(content, path) do
    content
    |> extract_elixir_code_fences()
    |> Enum.map(&LiveViewNative.Stylesheet.Extractor.extract_templates/1)
    |> List.flatten()
    |> Enum.map(&LiveViewNative.Stylesheet.Extractor.parse_style(elem(&1, 0), path, elem(&1, 1)))
  end

  defp extract_elixir_code_fences(content) do
    {:ok, ast, _} = EarmarkParser.as_ast(content)

    Enum.reduce(ast, [], fn
      {"pre", _, [{"code", [{"class", "elixir"}], [code], _}], _}, acc -> [code | acc]
      _, acc -> acc
    end)
  end
end
