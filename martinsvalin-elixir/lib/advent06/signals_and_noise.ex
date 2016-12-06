defmodule Advent.SignalsAndNoise do
  @moduledoc """
  # Advent of Code, Day 6: Signals and Noise

  See: http://adventofcode.com/2016/day/5
  """

  @spec error_correct_by_most_frequent(String.t) :: String.t
  def error_correct_by_most_frequent(input), do: error_correct(input, &Enum.max_by/2)

  @spec error_correct_by_least_frequent(String.t) :: String.t
  def error_correct_by_least_frequent(input), do: error_correct(input, &Enum.min_by/2)

  @doc """
  Error correct a message based on repetition codes

  ## Examples

      iex> input = "eedadn\\ndrvtee\\neandsr\\nraavrd\\natevrs\\ntsrnev\\nsdttsa\\nrasrtv\\nnssdts\\nntnada\\nsvetve\\ntesnvt\\nvntsnd\\nvrdear\\ndvrsen\\nenarar"
      iex> error_correct(input, &Enum.max_by/2)
      "easter"
  """
  @spec error_correct(String.t, fun) :: String.t
  def error_correct(input, picker) do
    input
    |> String.split
    |> Enum.map(&String.to_charlist/1)
    |> transpose
    |> Enum.map(&letter_frequency/1)
    |> Enum.map(&pick_letter_by_frequency(&1, picker))
    |> to_string
  end

  defp transpose(list) do
    list |> List.zip |> Enum.map(&Tuple.to_list/1)
  end

  defp letter_frequency(letters) do
    Enum.reduce(letters, %{}, fn letter, acc -> Map.update(acc, letter, 1, & &1 + 1) end)
  end

  defp pick_letter_by_frequency(frequency_map, picker) do
    picker.(frequency_map, fn {_, freq} -> freq end) |> elem(0)
  end
end
