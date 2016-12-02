defmodule Advent.BathroomSecurity do
  @moduledoc """
  # Advent of Code, Day 2: Bathroom Security

  See: http://adventofcode.com/2016/day/2
  """

  @doc """
  Decode the bathroom code from instructions to move on a keypad.

  The keypad can be of two shapes: `:normal` or `:star`. The first is the common
  3x3 keypad, and is the default shape. The second is a star-shaped keypad laid
  out like this:

      1
    2 3 4
  5 6 7 8 9
    A B C
      D

  ## Examples

      iex> decode("ULL\\nRRDDD\\nLURDL\\nUUUUD", :normal)
      "1985"

      iex> decode("ULL\\nRRDDD\\nLURDL\\nUUUUD", :star)
      "5DB3"
  """
  @spec decode(String.t) :: String.t
  @spec decode(String.t, :normal | :star) :: String.t
  def decode(instructions, shape \\ :normal) do
    case shape do
      :normal -> decode_3x3(instructions, 5, [])
      :star -> decode_star(instructions, 5, [])
    end
    |> Enum.reverse
    |> Enum.join
  end

  defp decode_3x3("", key, code), do: [key | code]
  defp decode_3x3("\n" <> rest, key, code), do: decode_3x3(rest, key, [key | code])

  defp decode_3x3("U" <> rest, key, code) when key in [1, 2, 3], do: decode_3x3(rest, key, code)
  defp decode_3x3("U" <> rest, key, code), do: decode_3x3(rest, key - 3, code)

  defp decode_3x3("D" <> rest, key, code) when key in [7, 8, 9], do: decode_3x3(rest, key, code)
  defp decode_3x3("D" <> rest, key, code), do: decode_3x3(rest, key + 3, code)

  defp decode_3x3("L" <> rest, key, code) when key in [1, 4, 7], do: decode_3x3(rest, key, code)
  defp decode_3x3("L" <> rest, key, code), do: decode_3x3(rest, key - 1, code)

  defp decode_3x3("R" <> rest, key, code) when key in [3, 6, 9], do: decode_3x3(rest, key, code)
  defp decode_3x3("R" <> rest, key, code), do: decode_3x3(rest, key + 1, code)

  @up %{            1 => 1,
            2 => 2, 3 => 1,  4 => 4,
    5 => 5, 6 => 2, 7 => 3,  8 => 4, 9 => 9,
           "A"=> 6,"B"=> 7, "C"=> 8,
                   "D"=>"B"
       }

  @down %{          1 => 3,
           2 => 6,  3 => 7,  4 => 8,
    5 => 5,6 =>"A", 7 =>"B", 8 => "C", 9 => 9,
          "A"=>"A","B"=>"D","C"=>"C",
                   "D"=>"D"
       }

  @left %{          1 => 1,
           2 => 2,  3 => 2,  4 => 3,
    5 => 5,6 => 5,  7 => 6,  8 => 7, 9 => 8,
          "A"=>"A","B"=>"A","C" => "B",
                   "D"=>"D"
       }

  @right %{         1 => 1,
            2 => 3, 3 => 4, 4 => 4,
    5 => 6, 6 => 7, 7 => 8, 8 => 9, 9 => 9,
          "A"=>"B","B"=>"C","C"=>"C",
                   "D"=>"D"
       }

  defp decode_star("", key, code), do: [key | code]
  defp decode_star("\n" <> rest, key, code), do: decode_star(rest, key, [key | code])

  defp decode_star("U" <> rest, key, code), do: decode_star(rest, @up[key], code)
  defp decode_star("D" <> rest, key, code), do: decode_star(rest, @down[key], code)
  defp decode_star("L" <> rest, key, code), do: decode_star(rest, @left[key], code)
  defp decode_star("R" <> rest, key, code), do: decode_star(rest, @right[key], code)
end
