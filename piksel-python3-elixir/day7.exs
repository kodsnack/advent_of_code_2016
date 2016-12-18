
# AOC Day #7 Solution
# </> nils måsen, piksel bitworks

defmodule Day7 do

  def solution_one(input) do
    for row <- input |> String.split do
      Regex.scan(~r/(?:\[([a-z]+)\])?([a-z]+)+/, row)
      |> Enum.map(fn(x) ->
        [ is_four_token(Enum.at(x, 1)), is_four_token(Enum.at(x, 2)) ]
      end)
    end
    |> Enum.filter(fn(x) ->
      Enum.any?(x, fn(y) -> Enum.at(y, 1) end) and not
      Enum.any?(x, fn(y) -> Enum.at(y, 0) end)
    end)
    |> Enum.count
    |> Integer.to_string
  end

  def solution_two(input) do
    for row <- input |> String.split do
      threes = Regex.scan(~r/(?:\[([a-z]+)\])?([a-z]+)+/, row)
      |> Enum.map(fn(x) ->
        [ get_three_tokens(Enum.at(x, 1)), get_three_tokens(Enum.at(x, 2)) ]
      end)

      abas = Enum.map(threes, fn(x) -> Enum.at(x, 1) end) |> Enum.concat
      babs = Enum.map(threes, fn(x) -> Enum.at(x, 0) end) |> Enum.concat
      true in for aba <- abas, bab <- babs do
        threes_match(aba, bab)
      end
    end
    |> Enum.filter(fn(x) -> x end)
    |> Enum.count
    |> Integer.to_string
  end

  def is_four_token(""), do: false
  def is_four_token(target) do
    true in for offset <- 0..String.length(target)-4 do
      subtarget = String.slice(target, offset, 4)
      {first, second} = String.split_at(subtarget, 2)
      first != second and first == String.reverse(second)
    end
  end

  def get_three_tokens(""), do: []
  def get_three_tokens(target) do
    for offset <- 0..String.length(target)-3 do
      subtarget = String.slice(target, offset, 3)
      [first, second, third] = String.to_charlist(subtarget)
      if first != second and first == third do
        subtarget
      else
        nil
      end
    end
  end

  def threes_match(nil, _), do: false
  def threes_match(_, nil), do: false
  def threes_match(aba, bab) do
    String.slice(aba, 0, 2) == String.slice(bab, 1, 2)
  end

  def run([]), do: "No input file specified" |> IO.puts
  def run([input_file|_]) do
    "Solutions for Day #7, given inputs from #{input_file}:" |> IO.puts
    case File.read(input_file) do
      {:ok, input} ->
        " - Part 1: " <> solution_one(input) |> IO.puts
        " - Part 2: " <> solution_two(input) |> IO.puts
      {:error, reason} ->
        "Error opening file: #{reason}" |> IO.puts
    end
  end

end

Day7.run(System.argv)
