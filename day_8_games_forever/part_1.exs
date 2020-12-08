defmodule Game do
  def find_loop(program, execution_index \\ 0, start_acc \\ 0) do
    case line_at(program, execution_index) do
      {_line, _visited_acc} -> start_acc
      line ->
        {next_line, acc} = execute_line(line, execution_index, start_acc)
        find_loop(visit_line(program, execution_index, start_acc), next_line, acc)
    end
  end

  defp line_at([first | _rest], 0), do: first
  defp line_at(list, line), do: Enum.at(list, line)

  defp execute_line("nop" <> _rest, index, acc), do: {index + 1, acc}

  defp execute_line("jmp " <> num, index, acc) do
    num = String.to_integer(num)
    {index + num, acc}
  end

  defp execute_line("acc " <> num, index, acc) do
    num = String.to_integer(num)
    {index + 1, acc + num}
  end

  defp visit_line([first | rest], 0, acc) do
    [{first, acc} | rest]
  end

  defp visit_line(program, line, acc) do
    List.update_at(program, line, &{&1, acc})
  end
end

"input.txt"
|> File.read!()
|> String.split("\n")
|> Game.find_loop()
|> IO.inspect()
