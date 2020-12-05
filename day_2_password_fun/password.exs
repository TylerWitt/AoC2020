defmodule PasswordHelper do
  def valid_password?(line) do
    [rules, password] = String.split(line, ": ", trim: true)
    [range, letter] = String.split(rules)
    [min, max] = String.split(range, "-")

    min = String.to_integer(min)
    max = String.to_integer(max)

    password
    |> String.codepoints()
    |> Enum.reduce_while(0, &check_letter(&1, &2, max, letter))
    |> case do
      num when is_integer(num) and num in min..max ->
        true

      _ ->
        false
    end
  end

  def check_letter(_letter, occurrences, max, _pw_letter) when occurrences > max do
    {:halt, :exceeded}
  end

  def check_letter(letter, occurrences, _max, letter) do
    {:cont, occurrences + 1}
  end

  def check_letter(_letter, occurrences, _max, _pw_letter) do
    {:cont, occurrences}
  end
end

for line <- File.stream!("input.txt"), PasswordHelper.valid_password?(line), reduce: 0 do
  acc -> acc + 1
end
|> IO.inspect()
