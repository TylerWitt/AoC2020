defmodule Luggage do
  def build_vertex(luggage_graph, line) do
    [bag_color, contents] = String.split(line, " bags contain ")

    :digraph.add_vertex(luggage_graph, bag_color)

    contents
    |> String.split(", ")
    |> Enum.each(&build_edge(luggage_graph, bag_color, &1))
  end

  defp build_edge(_luggage_graph, _parent_vertex, "no other bags"), do: nil

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

  def summarize_edges(graph, vertex) do
    graph
    |> :digraph.out_edges(vertex)
    |> edge_values(graph)
  end

  defp edge_values([], _graph), do: 1

  defp edge_values([edge | rest], graph) do
    {_edge, _from, to_vertex, val} = :digraph.edge(graph, edge)
    IO.inspect(:digraph.edge(graph, edge))
    (String.to_integer(val) * summarize_edges(graph, to_vertex)) + edge_values(rest, graph)
  end
end

luggage_graph = :digraph.new()

"input.txt"
|> File.stream!()
|> Stream.map(&String.trim_trailing(String.trim_trailing(&1, "\n"), "."))
|> Enum.each(&Luggage.build_vertex(luggage_graph, &1))

luggage_graph
|> Luggage.summarize_edges("shiny gold")
|> Kernel.-(1)
|> IO.inspect()
