defmodule XMAS do
  def find_weakness(cipher, target_val) do
    range =
      Enum.reduce_while(cipher, 0, fn _cipher_root, idx ->
        range = idx..Enum.count(cipher)
        Enum.reduce_while(range, 0, fn check_idx, acc ->
          cur_sum = acc + Enum.at(cipher, check_idx)
          cond do
            cur_sum < target_val ->
              {:cont, cur_sum}

            cur_sum == target_val ->
              {:halt, check_idx}

            cur_sum > target_val ->
              {:halt, :too_big}
          end
        end)
        |> case do
          :too_big ->
            {:cont, idx + 1}

          max_idx ->
            {:halt, idx..max_idx}
        end
      end)

    min.._max = range

    vals = cipher
    |> Enum.drop(min)
    |> Enum.take(Enum.count(range))

    Enum.min(vals) + Enum.max(vals)
  end
end

"input.txt"
|> File.read!()
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> XMAS.find_weakness(1124361034)
|> IO.inspect()
