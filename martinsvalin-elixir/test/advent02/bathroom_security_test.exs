defmodule Advent.BathroomSecurityTest do
  use ExUnit.Case
  import Advent.BathroomSecurity
  doctest Advent.BathroomSecurity

  describe "decoding for a normal 3x3 keypad" do
    test "Single line, go up once from 5 to 2" do
      assert decode("U") == "2"
    end

    test "Single line, go up twice, but stay at 2" do
      assert decode("UU") == "2"
    end

    test "Single line, all directions ends back at 5" do
      assert decode("ULDR") == "5"
    end

    test "Mulitple lines" do
      assert decode("U\nD\nL\nR") == "2545"
    end
  end

  describe "decoding for a star-shaped keypad" do
    test "Single line, go up once from 5, but stay on 5" do
      assert decode("U", :star) == "5"
    end

    test "Single line, go right four times from 5, and end up on 9" do
      assert decode("RRRR", :star) == "9"
    end

    test "Single line, go to D" do
      assert decode("RRDD", :star) == "D"
    end
  end
end
