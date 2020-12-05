defmodule PasswordHelper do
  def valid_password?(line) do
    [rules, password] = String.split(line, ": ", trim: true)
    [range, letter] = String.split(rules)
    [min, max] = String.split(range, "-")

    min = String.to_integer(min)
    max = String.to_integer(max)

    password_pts = String.codepoints(password)

    first_match = matches_letter_at?(password_pts, letter, min)
    second_match = matches_letter_at?(password_pts, letter, max)

    (first_match || second_match) && (first_match != second_match)
  end

  def matches_letter_at?(password_pts, letter, location) do
    Enum.at(password_pts, location - 1) == letter
  end
end

for line <- File.stream!("input.txt"), PasswordHelper.valid_password?(line), reduce: 0 do
  acc -> acc + 1
end
|> IO.inspect()
