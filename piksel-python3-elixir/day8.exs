
# AOC 2016 Day #8 Solution
# </> nils måsén, piksel bitworks

defmodule Day8 do

  @col_count 50
  @row_count 6

  def solution_one(input) do
    update_matrix(String.split(input, "\r\n"))
    |> List.flatten
    |> Enum.filter(fn(x) -> x end)
    |> Enum.count
  end

  def solution_two(input) do
    update_matrix(String.split(input, "\r\n"))
    |> display_matrix
  end

  def update_matrix(instructions) do
    matrix = for _ <- 0..@row_count, do: for _ <- 1..@col_count, do: false
    update_matrix(matrix, instructions)
  end

  def update_matrix(matrix, []), do: matrix
  def update_matrix(matrix, instructions) do

    instruction = List.first(instructions)

    matrix = cond do
      instruction =~ "rect" ->
        [_, xs, ys] = Regex.run(~r/rect ([0-9]+)x([0-9]+)/, instruction)
        make_rect(matrix, String.to_integer(xs), String.to_integer(ys))

      instruction =~ "rotate" ->
        rotate_pattern = ~r/rotate (column|row) (x|y)=([0-9]+) by ([0-9]+)/
        [_, dir, _, pos_s, offset_s] = Regex.run(rotate_pattern, instruction)
        rotate_matrix(matrix, dir, String.to_integer(pos_s), String.to_integer(offset_s))
      instruction == "" ->
        matrix
    end

    display_matrix(matrix)
    update_matrix(matrix, Enum.drop(instructions, 1) )
  end

  def make_rect(matrix, x, y) do
    for row <- 0..@row_count-1 do
      for col <- 0..@col_count-1 do
        (matrix |> Enum.at(row) |> Enum.at(col)) or (row < y and col < x)
      end
    end
  end

  def rotate_matrix(matrix, "column", pos, offset) do
    for row <- 0..@row_count-1 do
      for col <- 0..@col_count-1 do
        if pos == col do
          old_row = rem(row - offset, @row_count)
          matrix |> Enum.at(old_row) |> Enum.at(col)
        else
          matrix |> Enum.at(row) |> Enum.at(col)
        end
      else
        matrix_row
      end
    end
  end

  def rotate_matrix(matrix, "row", pos, offset) do
      for row <- 0..@row_count-1 do
        matrix_row = matrix |> Enum.at(row)
        if pos == row do
          for col <- 0..@col_count-1 do
            old_col = rem(col - offset, @col_count)
            (matrix_row |> Enum.at( old_col ))
          end
        else
          matrix_row
        end
      end
  end

  def display_matrix(matrix) do
    for row <- matrix do
      [
        " ",
        for bit <- row do
          if bit, do: "\#", else: " "
        end,
        "\n"
      ]
    end
    |> List.flatten
    |> List.to_string
  end

  def run([]), do: "No input file specified" |> IO.puts
  def run([input_file|_]) do
    "Solutions for Day #8, given inputs from #{input_file}:" |> IO.puts
    case File.read(input_file) do
      {:ok, input} ->
        output_one = solution_one(input)
        " - Part 1: #{output_one}" |> IO.puts
        output_two = solution_two(input)
        " - Part 2: \n#{output_two}" |> IO.puts
      {:error, reason} ->
        "Error opening file: #{reason}" |> IO.puts
    end
  end

end

Day8.run(System.argv)
