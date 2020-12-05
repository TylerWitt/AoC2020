defmodule Validator do
  @req_attrs ~w(byr iyr eyr hgt hcl ecl pid)a
  @opt_attrs ~w(cid)a

  @valid_ecl ~w(amb blu brn gry grn hzl oth)

  @req_mapset MapSet.new(@req_attrs)

  def attr_pass?(attributes) do
    attribute_mapset =
      attributes
      |> Keyword.keys()
      |> MapSet.new()

    if (MapSet.difference(@req_mapset, attribute_mapset) == MapSet.new()) do
      all_attr_valid?(attributes)
    else
      false
    end
  end

  defp all_attr_valid?(attributes) do
    Enum.reduce_while(attributes, true, fn attribute, _acc ->
      if attr_valid?(attribute) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  defp attr_valid?({:byr, val}) do
    int_byr = String.to_integer(val)

    int_byr in 1920..2002
  end

  defp attr_valid?({:cid, _val}), do: true

  defp attr_valid?({:ecl, val}) when val in @valid_ecl, do: true

  defp attr_valid?({:eyr, val}) do
    int_eyr = String.to_integer(val)

    int_eyr in 2020..2030
  end

  defp attr_valid?({:hcl, "#" <> <<hex::binary-size(6)>>}) do
    String.match?(hex, ~r/[0-9a-f]*/)
  end

  defp attr_valid?({:hgt, val}) do
    {num, unit} = Integer.parse(val)

    case unit do
      "cm" -> num in 150..193
      "in" -> num in 59..76
      _ -> false
    end
  end

  defp attr_valid?({:iyr, val}) do
    int_iyr = String.to_integer(val)

    int_iyr in 2010..2020
  end

  defp attr_valid?({:pid, <<val::binary-size(9)>>}) do
    String.match?(val, ~r/[0-9]*/)
  end

  defp attr_valid?(_tuple), do: false

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
