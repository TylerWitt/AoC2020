defmodule Seating do
  def simulate(seat_map) do
    new_seat_map = simulation(seat_map)

    if seat_map == new_seat_map do
      seat_map
    else
      simulate(new_seat_map)
    end
  end

  defp simulation(seat_map) do
    Map.new(seat_map, fn {index, row} ->
      {index, Map.new(row, &evaluate_cell(&1, index, seat_map))}
    end)
  end

  defp evaluate_cell({cell_index, "."}, _row_index, _seat_map), do: {cell_index, "."}

  defp evaluate_cell({cell_index, "L"}, row_index, seat_map) do
    if Enum.any?(adjacent_seats(seat_map, row_index, cell_index), & &1 == "#") do
      {cell_index, "L"}
    else
      {cell_index, "#"}
    end
  end

  defp evaluate_cell({cell_index, "#"}, row_index, seat_map) do
    seat_map
    |> adjacent_seats(row_index, cell_index)
    |> Enum.filter(& &1 == "#")
    |> Enum.count()
    |> case do
      count when count >= 4 -> {cell_index, "L"}
      _ -> {cell_index, "#"}
    end
  end

  defp adjacent_seats(seat_map, row_index, cell_index) do
    [
      seat_map[row_index][cell_index + 1],
      seat_map[row_index][cell_index - 1],
      seat_map[row_index + 1][cell_index],
      seat_map[row_index - 1][cell_index],
      seat_map[row_index - 1][cell_index - 1],
      seat_map[row_index - 1][cell_index + 1],
      seat_map[row_index + 1][cell_index - 1],
      seat_map[row_index + 1][cell_index + 1]
    ]
    |> Enum.filter(& &1)
  end
end

"input.txt"
|> File.read!()
|> String.split("\n")
|> Enum.with_index()
|> Map.new(fn {line, index} ->
  new_line =
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Map.new(&{elem(&1, 1), elem(&1, 0)})

  {index, new_line}
end)
|> Seating.simulate()
|> Enum.reduce(0, fn {_idx, row}, acc -> acc + Enum.count(row, fn {_cell_idx, cell} -> cell == "#" end) end)
|> IO.inspect()
