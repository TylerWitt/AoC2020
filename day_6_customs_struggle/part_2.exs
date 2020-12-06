defmodule Customs do
  def group(str) do
    str
    |> String.split("\n", trim: true)
    |> intersect_answers()
  end

  defp intersect_answers([first | list]) do
    Enum.reduce(list, MapSet.new(String.codepoints(first)), fn str, acc ->
      MapSet.intersection(MapSet.new(String.codepoints(str)), acc)
    end)
  end

  # One person's answers
  defp intersect_answers(str), do: str
end

chunk_fn =
  fn line, acc ->
    case line do
      "\n" -> {:cont, Customs.group(acc), ""}
      line -> {:cont, acc <> line}
    end
  end

"input.txt"
|> File.stream!()
|> Stream.chunk_while("", chunk_fn, fn acc -> {:cont, Customs.group(acc), ""} end)
|> Stream.map(&Enum.count/1)
|> Enum.sum()
|> IO.inspect()
