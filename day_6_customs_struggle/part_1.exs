defmodule Customs do
  def group(str) do
    str
    |> String.graphemes()
    |> Enum.group_by(& &1)
    |> Map.keys()
  end
end

chunk_fn =
  fn line, acc ->
    case line do
      "\n" -> {:cont, Customs.group(acc), ""}
      line -> {:cont, acc <> String.trim(line)}
    end
  end

"input.txt"
|> File.stream!()
|> Stream.chunk_while("", chunk_fn, fn acc -> {:cont, Customs.group(acc), ""} end)
|> Stream.map(&Enum.count/1)
|> Enum.sum()
|> IO.inspect()
