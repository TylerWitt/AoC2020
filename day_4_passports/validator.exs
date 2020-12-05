defmodule Validator do
  @req_attrs ~w(byr iyr eyr hgt hcl ecl pid)a
  @opt_attrs ~w(cid)a

  @req_mapset MapSet.new(@req_attrs)

  def attr_pass?(attributes) do
    attribute_mapset =
      attributes
      |> Keyword.keys()
      |> MapSet.new()

    (MapSet.difference(@req_mapset, attribute_mapset) == MapSet.new())
  end

  def keywordify_attributes(chunk) do
    chunk
    |> String.split([" ", "\n"], trim: true)
    |> Keyword.new(fn attribute ->
      [attr, val] = String.split(attribute, ":")
      {String.to_atom(attr), val}
    end)
  end
end

chunk_fn =
  fn line, acc ->
    case line do
      "\n" -> {:cont, Validator.keywordify_attributes(acc), ""}
      line -> {:cont, acc <> line}
    end
  end

stream =
  "input.txt"
  |> File.stream!()
  |> Stream.chunk_while("", chunk_fn, fn acc -> {:cont, Validator.keywordify_attributes(acc), ""} end)

Enum.count(stream, &Validator.attr_pass?/1)
|> IO.inspect()
