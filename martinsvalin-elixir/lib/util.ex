defmodule Util do
  @doc """
  Convert string to integer

  Convenience function to not have to match the tuple giving the rest of the string.
  This function will fail if the string cannot be fully parsed as an integer.

  ## Examples

      iex> Util.to_int("123")
      123
  """
  def to_int(string) when is_binary(string) do
    {int, ""} = Integer.parse(string)
    int
  end


  @doc """
  Invert a map. Does not handle duplicate values.

  ## Examples

      iex> Util.invert_map(%{a: 1, b: 2})
      %{1 => :a, 2 => :b}
  """
  def invert_map(map) when is_map(map) do
    for {x,y} <- map, into: Map.new, do: {y,x}
  end
end
