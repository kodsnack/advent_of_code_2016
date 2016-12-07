defmodule Advent.Ipv7 do
  @moduledoc """
  # Advent of Code, Day 7: Internet Protocol Version 7

  See: http://adventofcode.com/2016/day/7
  """

  @doc """
  Determine if an IPv7 address supports TLS

  An address that supports TLS is marked with an ABBA pattern. It must not have
  any ABBA pattern in hypernet sequences, marked by enclosing brackets.

  ## Examples

      iex> support_tls?("abba[mnop]qrst")
      true

      iex> support_tls?("abcd[bddb]xyyx")
      false
  """
  @spec support_tls?(String.t) :: boolean
  def support_tls?(address) do
    parts = grouped_parts(address)

    Enum.any?(parts.supernet, &abba?/1) && Enum.all?(parts.hypernet, & !abba?(&1))
  end


  @doc """
  Determine if an IPv7 address support SSL

  An address that supports SSL has an ABA pattern in its supernet sequence with
  a corresponding BAB pattern in its hypernet sequence.

  ## Examples

      iex> support_ssl? "aba[bab]xyz"
      true

      iex> support_ssl? "xyx[xyx]xyx"
      false

      iex> support_ssl? "zazbz[bzb]cdb"
      true
  """
  @spec support_ssl?(String.t) :: boolean
  def support_ssl?(address) do
    parts = grouped_parts(address)

    supernet_abas = Enum.flat_map(parts.supernet, &abas/1)
    hypernet_abas = Enum.flat_map(parts.hypernet, &abas/1)

    Enum.any?(supernet_abas, fn aba -> bab?(aba, hypernet_abas) end)
  end

  @doc """
  Parse a IPv7 address, categorizing its parts

  ## Examples

      iex> grouped_parts("abba[mnop]qrst")
      %{supernet: ["abba", "qrst"], hypernet: ["mnop"]}
  """
  @spec grouped_parts(String.t) :: map
  def grouped_parts(address), do: grouped_parts(address, [supernet: ""])

  defp grouped_parts("", parts) do
    parts
    |> Enum.reverse
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
  end
  defp grouped_parts("[" <> address, parts) do
    grouped_parts(address, [{:hypernet, ""} | parts])
  end
  defp grouped_parts("]" <> address, parts) do
    grouped_parts(address, [{:supernet, ""} | parts])
  end
  defp grouped_parts(<<letter>> <> address, [{key, part} | tail]) do
    grouped_parts(address, [{key, part <> <<letter>>} | tail])
  end


  @doc """
  Is there an ABBA pattern in the string?

  ## Examples

      iex> abba? "string with the abba pattern"
      true

      iex> abba? "no such pattern in here"
      false
  """
  @spec abba?(String.t) :: boolean
  def abba?(<<a, b, b, a>> <> _) when a != b, do: true
  def abba?(""), do: false
  def abba?(<<_>> <> rest), do: abba?(rest)


  @doc """
  List all examples of ABA patterns in the string

  ## Examples

      iex> abas "zazbz"
      ["zaz", "zbz"]
  """
  @spec abas(String.t) :: [String.t]
  def abas(string), do: abas(string, [])

  defp abas("", acc), do: Enum.reverse(acc)
  defp abas(<<a,b,a>> <> rest, acc) when a != b do
    abas(<<b, a>> <> rest, [<<a,b,a>> | acc])
  end
  defp abas(<<_>> <> rest, acc), do: abas(rest, acc)


  @doc """
  For an ABA sequence, is there a BAB sequence in the list

  ## Examples

      iex> bab?("aba", ["abc", "bab"])
      true

      iex> bab?("aba", ["aba"])
      false
  """
  @spec bab?(String.t, [String.t]) :: boolean
  def bab?(_aba, []), do: false
  def bab?(<<a,b,a>>, [<<b,a,b>> | _]), do: true
  def bab?(aba, [_ | tail]), do: bab?(aba, tail)
end
