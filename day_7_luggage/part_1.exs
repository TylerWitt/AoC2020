defmodule Luggage do
  def build_vertex(luggage_graph, line) do
    [bag_color, contents] = String.split(line, " bags contain ")

    :digraph.add_vertex(luggage_graph, bag_color)

    contents
    |> String.split(", ")
    |> Enum.each(&build_edge(luggage_graph, bag_color, &1))
  end

  defp build_edge(luggage_graph, parent_vertex, <<num::binary-size(1), _space::binary-size(1), bag_color::binary>>) do
    bag_color = trim_bag(bag_color, num)

    if :digraph.vertex(luggage_graph, bag_color) == false do
      :digraph.add_vertex(luggage_graph, bag_color)
    end

    :digraph.add_edge(luggage_graph, parent_vertex, bag_color, num)
  end

  defp trim_bag(bag_color, "1") do
    String.trim_trailing(bag_color, " bag")
  end

  defp trim_bag(bag_color, _num) do
    String.trim_trailing(bag_color, " bags")
  end

  def find_parents(graph, vertex) do
    in_neighbors = graph |> :digraph.in_neighbours(vertex)

    [vertex | Enum.map(in_neighbors, &find_parents(graph, &1))]
  end
end

luggage_graph = :digraph.new()

"input.txt"
|> File.stream!()
|> Stream.map(&String.trim_trailing(String.trim_trailing(&1, "\n"), "."))
|> Enum.each(&Luggage.build_vertex(luggage_graph, &1))

luggage_graph
|> Luggage.find_parents("shiny gold")
|> List.flatten()
|> Enum.uniq()
|> Enum.count()
|> Kernel.-(1)
|> IO.inspect()
