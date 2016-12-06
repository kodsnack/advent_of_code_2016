defmodule Advent.NoTimeForTaxicab do
  @moduledoc """
  # Advent of Code, Day 1: No Time for a Taxicab

  See: http://adventofcode.com/2016/day/1
  """

  @typep position :: {integer, integer}
  @typep turn :: <<_ :: 8>>

  @doc """
  Carry out walking instructions, keeping track of all positions.

  Positions are given as {x,y} coordinates, from a start position at {0,0}. The
  final position is given at the head of the list.
  The input can be both an unparsed text, or a list of turn directions and distances.

  ## Examples

      iex> follow_instructions("R2, L3")
      [{-2, 3}, {-2, 2}, {-2, 1}, {-2, 0}, {-1, 0}, {0, 0}]
      iex> follow_instructions([{?R, 2}, {?R, 2}, {?R, 2}])
      [{0, -2}, {-1, -2}, {-2, -2}, {-2, -1}, {-2, 0}, {-1, 0}, {0, 0}]
  """
  @spec follow_instructions(String.t) :: [position, ...]
  @spec follow_instructions([{turn, pos_integer}]) :: [position, ...]
  def follow_instructions(input) when is_binary(input) do
    parse(input) |> follow_instructions
  end
  def follow_instructions(input) do
    follow_instructions(input, :north, [{0,0}])
  end

  defp follow_instructions([], _, positions), do: positions
  defp follow_instructions([{right_or_left, distance}| rest], direction, positions) do
    new_direction = turn(right_or_left, direction)
    new_positions = walk(positions, new_direction, distance)
    follow_instructions(rest, new_direction, new_positions)
  end

  @turn_right %{ north: :west, west: :south, south: :east, east: :north }
  @turn_left Util.invert_map(@turn_right)

  defp turn(?R, from_direction), do: @turn_right[from_direction]
  defp turn(?L, from_direction), do: @turn_left[from_direction]

  defp walk(positions, _dir, 0), do: positions
  defp walk([position | _] = positions, direction, distance) do
    [step(position, direction) | positions]
    |> walk(direction, distance - 1)
  end

  defp step({x, y}, :north), do: {x, y + 1}
  defp step({x, y}, :south), do: {x, y - 1}
  defp step({x, y}, :east), do: {x + 1, y}
  defp step({x, y}, :west), do: {x - 1, y}


  @doc """
  The length of the shortest path to a position, from the origin

  ## Examples

      iex> distance_from_start({2, 3})
      5
      iex> distance_from_start({0, -2})
      2
  """
  @spec distance_from_start(position) :: integer
  def distance_from_start({x, y}), do: abs(x) + abs(y)


  @doc """
  Find the first position in the list that was visited twice.

  ## Examples

      iex> positions = follow_instructions("R8, R4, R4, R8") |> Enum.reverse
      iex> first_visited_twice(positions)
      {-4, 0}
  """
  @spec first_visited_twice([position, ...]) :: position
  def first_visited_twice(positions), do: first_visited_twice(positions, [])

  defp first_visited_twice([h | t], seen) do
    case h in seen do
      true -> h
      false -> first_visited_twice(t, [h | seen])
    end
  end

  # Turns "R2, L3" into [{?R, 2}, {?L, 3}]
  defp parse(text) do
    text
    |> String.trim
    |> String.split(", ")
    |> Enum.map(&parse_instruction/1)
  end

  # Turns "R12" into {?R, 12}
  defp parse_instruction(<<direction :: 8>> <> distance) do
    {direction, Util.to_int(distance)}
  end
end
