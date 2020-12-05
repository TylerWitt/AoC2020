"input.txt"
|> File.read!()
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
# I'm willing to bet that because there are 3 numbers, the high end of this list won't have
# the solution.
|> Enum.sort()
|> Enum.reduce_while([], fn int, acc ->
  case Enum.find(acc, &elem(&1, 0) == int && Enum.count(elem(&1, 1)) == 2) do
    {_target, [num_1, num_2]} ->
      {:halt, int * num_1 * num_2}
    _ ->
      new_entries =
        for {_key, [val]} <- acc, val + int < 2020 do
          {2020 - val - int, [val, int]}
        end

      new_acc = acc ++ [{2020 - int, [int]} | new_entries]

      {:cont, new_acc}
  end
end)
|> IO.inspect()
