sorted =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

map =
  [0 | sorted]
  |> Kernel.++([List.last(sorted) + 3])
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.group_by(fn [first, second] -> second - first end)

one_map =
  map
  |> Map.get(1)
  |> Enum.count()

three_map =
  map
  |> Map.get(3)
  |> Enum.count()

one_map * three_map
|> IO.inspect()
