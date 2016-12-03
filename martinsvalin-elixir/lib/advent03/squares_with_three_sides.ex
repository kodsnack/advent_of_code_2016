defmodule Advent.SquaresWithThreeSides do
  @moduledoc """
  # Advent of Code, Day 3: Squares With Three Sides

  See: http://adventofcode.com/2016/day/3
  """

  @typep triplet :: {pos_integer, pos_integer, pos_integer}

  @doc """
  Count the number of possible triangles, given the input side lengths.

  The second argument should be a function for how to extract 3-tuples from the
  input. See `triplets_in_rows/1` and `triplets_in_columns/1`.

  ## Examples

      iex> count_triangles("5 5 5 \\n 5 10 25 \\n 25 5 21", &triplets_in_rows/1)
      2

      iex> count_triangles("5 5 5 \\n 5 10 25 \\n 25 5 21", &triplets_in_columns/1)
      1
  """
  @spec count_triangles(String.t, fun) :: pos_integer
  def count_triangles(input, triplet_extractor) do
    input
    |> String.split("\n")
    |> Enum.map(&prepare_numbers/1)
    |> triplet_extractor.()
    |> Enum.count(&triangle?/1)
  end

  defp prepare_numbers(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&Util.to_int/1)
  end

  @doc """
  Take every row and transform to a 3-tuple

  ## Examples

      iex> triplets_in_rows([[1,2,3], [4,5,6], [7,8,9]])
      [{1,2,3}, {4,5,6}, {7,8,9}]
  """
  @spec triplets_in_rows([[pos_integer]]) :: [triplet]
  def triplets_in_rows(rows), do: Enum.map(rows, &List.to_tuple/1)

  @doc """
  Take three rows at a time, and transpose them, flatly, to a list of 3-tuples

  ## Examples

      iex> triplets_in_columns([[1,2,3], [4,5,6], [7,8,9]])
      [{1,4,7}, {2,5,8}, {3,6,9}]
  """
  @spec triplets_in_rows([[pos_integer]]) :: [triplet]
  def triplets_in_columns(rows) do
    rows
    |> Enum.chunk(3)
    |> Enum.flat_map(&List.zip/1)
  end

  @doc """
  Determine if the three sides can form a triangle

  ## Examples

      iex> triangle?({5, 5, 5})
      true
      iex> triangle?({5, 10, 25})
      false
  """
  @spec triangle?(triplet) :: boolean
  def triangle?({a,b,c}) when a + b > c
                         and  a + c > b
                         and  b + c > a,
                         do:  true
  def triangle?(_), do: false
end
