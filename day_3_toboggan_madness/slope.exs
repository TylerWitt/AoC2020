defmodule SlopeHelper do
  def char_at_location(line, location) do
    line_length = String.length(line)

    location =
      if location > line_length do
        location - line_length
      else
        location
      end

    {location, String.at(line, location - 1)}
  end
end

"input.txt"
|> File.stream!()
|> Enum.reduce({1, 0}, fn line, {location, trees} ->
  line = String.trim(line, "\n")

  case SlopeHelper.char_at_location(line, location) do
    {new_location, "#"} -> {new_location + 3, trees + 1}
    {new_location, _char} -> {new_location + 3, trees}
  end
end)
|> elem(1)
|> IO.inspect()
