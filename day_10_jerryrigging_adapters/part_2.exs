defmodule Adapter do
  def build_connections(list) do
    list
    |> trace_connections()
    |> Map.new()
  end

  defp trace_connections([_first]), do: []

  defp trace_connections([first | rest]) do
    paths = rest |> Enum.take_while(& &1 - first <= 3)

    [{first, paths} | trace_connections(rest)]
  end

  def unique_configurations(map, memo, [current_path | _tail] = path \\ [0]) do
    case Map.pop(map, current_path) do
      {nil, _map} -> 1
      {valid_paths, new_map} ->
        Enum.reduce(valid_paths, 0, fn new_path, acc ->
          sum_paths =
            case Agent.get(memo, &Map.get(&1, new_path)) do
              nil ->
                val = unique_configurations(new_map, memo, [new_path | path])
                Agent.update(memo, &Map.put(&1, new_path, val))

                val

              val ->
                val
            end
          acc + sum_paths
        end)
    end
  end
end

{:ok, memo} = Agent.start(fn -> %{} end)

sorted =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

max = List.last(sorted) + 3

[0 | sorted]
|> Kernel.++([max])
|> Adapter.build_connections()
|> Adapter.unique_configurations(memo)
|> IO.inspect()
