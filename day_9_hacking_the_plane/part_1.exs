defmodule XMAS do
  def invalid(cipher, preamble \\ [])

  def invalid(cipher, []) do
    {preamble, rem_cipher} = Enum.split(cipher, 25)

    invalid(rem_cipher, preamble)
  end

  def invalid([to_check | rem_cipher], [_rolling_off | rem_preamble] = preamble) do
    if valid?(preamble, to_check) do
      # appending a single item is wasteful, but faster (to write) than double reversing.
      invalid(rem_cipher, rem_preamble ++ [to_check])
    else
      to_check
    end
  end

  defp valid?([first | list], item) do
    Enum.reduce_while(list, [first], fn list_item, acc ->
      if Enum.any?(acc, &list_item + &1 == item) do
        {:halt, true}
      else
        {:cont, [list_item | acc]}
      end
    end)
    |> case do
      true -> true
      _ -> false
    end
  end
end

"input.txt"
|> File.read!()
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> XMAS.invalid()
|> IO.inspect()
