defmodule Advent.HowAboutANiceGameOfChess do
  @moduledoc """
  # Advent of Code, Day 5: How about a nice game of chess

  See: http://adventofcode.com/2016/day/5
  """

  @leading_zeroes 5
  @password_size 8

  @doc """
  Crack the password, given a seed, by finding 8 md5s with 5 leading zeroes.

  The method for building up the password from the hashes is given by the function
  passed in as a second argument.
  """
  @spec crack(String.t, fun) :: String.t
  def crack(key, door_rules) do
    key
    |> md5_stream
    |> Stream.filter(& String.starts_with?(&1, String.duplicate("0", @leading_zeroes)))
    |> door_rules.()
    |> String.downcase
  end

  @doc """
  Build a password from the first eight md5 hashes with leading zeroes.

  Use the sixth character to build a password.

  ## Examples

      iex> list = ["00000p","00000a","00000s","00000s","00000w","00000o","00000r","00000d"]
      iex> first_door(list)
      "password"
  """
  @spec first_door(Enumerable.t) :: String.t
  def first_door(md5s) do
    md5s
    |> Enum.take(8)
    |> Enum.map(& String.at(&1, @leading_zeroes))
    |> Enum.join
  end

  @doc """
  Build a password using positions taken from the md5 hashes.

  Use the sixth character in the md5 hash to position the seventh char in the
  password. Don't overwrite positions. Ignore positions that are not 0..7.

  ## Examples

      iex> list = ["000007d","000006r","000005o","000004w","000004x","000003s",
      ...>         "000002s", "000001a", "00000ax", "000000p", "000001x"]
      iex> second_door(list)
      "password"
  """
  @spec first_door(Enumerable.t) :: String.t
  def second_door(md5s) do
    Enum.reduce_while(md5s, %{}, &second_door_reducer/2)
  end

  defp second_door_reducer(_, %{?0=>a, ?1=>b, ?2=>c, ?3=>d, ?4=>e, ?5=>f, ?6=>g, ?7=>h}) do
    {:halt, <<a, b, c, d, e, f, g, h>>}
  end
  defp second_door_reducer("00000" <> <<pos :: 8, char :: 8>> <> _, acc) when pos in '01234567' do
    {:cont, Map.put_new(acc, pos, char)}
  end
  defp second_door_reducer(_, acc), do: {:cont, acc}

  @doc """
  Produce an everlasting stream of md5 hashes from a key with incrementing index

  ## Examples

      iex> md5_stream("abc") |> Enum.take(3)
      ["577571BE4DE9DCCE85A041BA0410F29F", "23734CD52AD4A4FB877D8A1E26E5DF5F", "63872B5565B2179BD72EA9C339192543"]
  """
  @spec md5_stream(String.t) :: Enumerable.t
  def md5_stream(key) do
    stream_of_numbers()
    |> Stream.map(& md5(key, &1))
  end

  defp stream_of_numbers, do: Stream.iterate(0, &(&1 + 1))

  defp md5(key, n) do
    key <> Integer.to_string(n)
    |> :erlang.md5
    |> Base.encode16
  end
end
