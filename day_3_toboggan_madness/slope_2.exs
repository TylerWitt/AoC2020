defmodule SlopeHelper do
  def trees_with_path(lines, right_step, down_step) do
    Enum.reduce(lines, {1, 0, 0}, fn line, {location, trees, line_count} ->
      if process_line?(down_step, line_count) do
        case char_at_location(line, location) do
          {new_location, "#"} -> {new_location + right_step, trees + 1, line_count + 1}
          {new_location, _char} -> {new_location + right_step, trees, line_count + 1}
        end
      else
        {location, trees, line_count + 1}
      end
    end)
    |> elem(1)
  end

  defp process_line?(1, _line), do: true

  defp process_line?(step, line), do: rem(line, step) == 0

  defp char_at_location(line, location) do
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

lines =
  "input.txt"
  |> File.read!()
  |> String.split("\n")

lines
|> SlopeHelper.trees_with_path(1, 1)
|> Kernel.*(SlopeHelper.trees_with_path(lines, 3, 1))
|> Kernel.*(SlopeHelper.trees_with_path(lines, 5, 1))
|> Kernel.*(SlopeHelper.trees_with_path(lines, 7, 1))
|> Kernel.*(SlopeHelper.trees_with_path(lines, 1, 2))
|> IO.inspect()
