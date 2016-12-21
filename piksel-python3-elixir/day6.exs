
# AOC Day #6 Solution
# </> nils måsen, piksel bitworks

defmodule Day6 do

  def solution_one(input) do
    get_chars_by_usage(input, &List.last/1)
  end

  def solution_two(input) do
    get_chars_by_usage(input, &List.first/1)
  end

  def get_chars_by_usage(input, list_sort_fun) do
    lines = input |> String.split
    lines_max = (lines |> List.first |> String.length) - 1
    Enum.map(0..lines_max, fn(col) ->
      lines |> Enum.group_by(fn(x) ->
        String.at(x, col)
      end)
      |> Map.values
      |> Enum.sort_by(&Enum.count/1)
      |> list_sort_fun.()
      |> List.last
      |> String.at(col)
    end)
    |> List.to_string
  end

  def run([]), do: "No input file specified" |> IO.puts
  def run([input_file|_]) do
    "Solutions for Day #6, given inputs from #{input_file}:" |> IO.puts
    case File.read(input_file) do
      {:ok, input} ->
        " - Part 1: " <> solution_one(input) |> IO.puts
        " - Part 2: " <> solution_two(input) |> IO.puts
      {:error, reason} ->
        "Error opening file: #{reason}" |> IO.puts
    end
  end

end

Day6.run(System.argv)
