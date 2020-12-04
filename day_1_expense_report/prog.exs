Enum.reduce_while(File.stream!("input.txt"), MapSet.new(), fn val, acc ->
  {int, _rem} = Integer.parse(val)

  if MapSet.member?(acc, int) do
    {:halt, (2020 - int) * int}
  else
    {:cont, MapSet.put(acc, 2020 - int)}
  end
end)
|> IO.inspect()
