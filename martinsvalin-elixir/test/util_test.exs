defmodule UtilTest do
  use ExUnit.Case
  doctest Util

  describe "to_int" do
    test "fails when input is not just an integer" do
      assert_raise(MatchError, fn -> Util.to_int "abc" end)
    end
  end

  describe "invert_map" do
    test "overwrites duplicate values" do
      assert Util.invert_map(%{a: 1, a: 2}) == %{2 => :a}
    end
  end
end
