defmodule Game do
  def fix_loop(program, execution_index \\ 0, start_acc \\ 0) do
    case test_operation(program, execution_index, start_acc) do
      {next_line, acc} ->
        fix_loop(program, next_line, acc)

      result -> result
    end
  end

  defp test_operation(program, execution_index, start_acc) do
    line = line_at(program, execution_index)
    case operation(line) do
      {"acc", _val} = operation ->
        execute_line(operation, execution_index, start_acc)

      original_operation ->
        test_program = switch_operation(program, execution_index, original_operation)

        case find_loop(test_program, execution_index, start_acc) do
          {:loop, _} ->
            execute_line(original_operation, execution_index, start_acc)

          {:ok, acc} -> acc
        end
    end
  end

  def find_loop(program, execution_index \\ 0, start_acc \\ 0)

  def find_loop([], _index, acc), do: {:ok, acc}

  def find_loop(program, execution_index, start_acc) do
    case line_at(program, execution_index) do
      nil -> {:ok, start_acc}
      {_line, _visited_acc} -> {:loop, start_acc}
      line ->
        {next_line, acc} = execute_line(operation(line), execution_index, start_acc)
        find_loop(visit_line(program, execution_index, start_acc), next_line, acc)
    end
  end

  defp line_at([first | _rest], 0), do: first
  defp line_at(list, line), do: Enum.at(list, line)

  defp operation(<<operation::binary-size(3), _space::binary-size(1), num::binary()>>) do
    {operation, String.to_integer(num)}
  end

  defp execute_line({"nop", _num}, index, acc), do: {index + 1, acc}
  defp execute_line({"jmp", num}, index, acc), do: {index + num, acc}
  defp execute_line({"acc", num}, index, acc), do: {index + 1, acc + num}

  defp switch_operation(program, index, {"jmp", num}) do
    List.replace_at(program, index, "nop #{num}")
  end

  defp switch_operation(program, index, {"nop", num}) do
    List.replace_at(program, index, "jmp #{num}")
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
|> Game.fix_loop()
|> IO.inspect()
