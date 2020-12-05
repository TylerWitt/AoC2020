defmodule Boarding do
  @min_row 0
  @max_row 127
  @min_seat 0
  @max_seat 7

  def seat_id(line) do
    {row_chars, seat_chars} = String.split_at(line, 7)
    row(row_chars, @min_row, @max_row) * 8 + seat(seat_chars, @min_seat, @max_seat)
  end

  defp row(_, num, num), do: num
  defp row("F" <> rest, min, max), do: row(rest, min, max - half_range(min..max))
  defp row("B" <> rest, min, max), do: row(rest, min + half_range(min..max), max)

  defp seat(_, num, num), do: num
  defp seat("L" <> rest, min, max), do: seat(rest, min, max - half_range(min..max))
  defp seat("R" <> rest, min, max), do: seat(rest, min + half_range(min..max), max)

  defp half_range(range), do: div(Enum.count(range), 2)
end

Enum.reduce(File.stream!("input.txt"), 0, fn line, acc ->
  case Boarding.seat_id(String.trim(line)) do
    seat_id when seat_id > acc -> seat_id
    _seat_id -> acc
  end
end)
|> IO.inspect()
