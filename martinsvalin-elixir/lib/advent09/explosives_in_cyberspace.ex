defmodule Advent.ExplosivesInCyberspace do
  @moduledoc """
  # Advent of Code, Day 9: Explosives in Cyberspace

  See: http://adventofcode.com/2016/day/9
  """


  @doc """
  Compute the size of the uncompressed string

  The compressed string has markers for length and count of repeated substrings.
  Thus, expand `"(3x2)abc"` to `"abcabc"`, giving the uncompressed size 6.
  Substring may contain marker-like patterns.

  The are two format versions. In version 1, the substrings are not themselves
  expanded. In version 2 they are. The default version is version 1.

  ## Examples

      iex> uncompressed_size("A(1x5)BC")
      7

      iex> uncompressed_size("(3x3)XYZ")
      9

      iex> uncompressed_size("(6x1)(1x3)A", :v1)
      6

      iex> uncompressed_size("(6x1)(1x3)A", :v2)
      3

      iex> uncompressed_size("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN", :v2)
      445
  """
  @spec uncompressed_size(String.t) :: pos_integer
  @spec uncompressed_size(String.t, :v1 | :v2) :: pos_integer
  def uncompressed_size(compressed), do: uncompressed_size(compressed, 0, :v1)
  def uncompressed_size(compressed, :v1), do: uncompressed_size(compressed, 0, :v1)
  def uncompressed_size(compressed, :v2), do: uncompressed_size(compressed, 0, :v2)

  defp uncompressed_size("", size, _version), do: size
  defp uncompressed_size("(" <> marker_and_string, size, version) do
    {length, repetitions, string} = parse_marker(marker_and_string)
    substring_size = case version do
      :v1 -> length
      :v2 -> uncompressed_size(binary_part(string, 0, length), 0, :v2)
    end

    string
    |> binary_drop(length)
    |> uncompressed_size(size + substring_size * repetitions, version)
  end
  defp uncompressed_size(<<_>> <> rest, size, version), do: uncompressed_size(rest, size + 1, version)


  defp parse_marker(string), do: parse_marker(string, [""])

  defp parse_marker(")" <> rest, [repetitions, length]) do
    {String.to_integer(length), String.to_integer(repetitions), rest}
  end
  defp parse_marker("x" <> rest, acc) do
    parse_marker(rest, ["" | acc])
  end
  defp parse_marker(<<c>> <> rest, [h | t]) when c in ?0..?9 do
    parse_marker(rest, [h <> <<c>> | t])
  end



  defp binary_drop(binary, n) do
    binary_part(binary, n, byte_size(binary) - n)
  end
end
