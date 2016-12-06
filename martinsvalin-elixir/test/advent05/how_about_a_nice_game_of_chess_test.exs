defmodule Advent.HowAboutANiceGameOfChessTest do
  use ExUnit.Case
  import Advent.HowAboutANiceGameOfChess
  doctest Advent.HowAboutANiceGameOfChess

  describe "first door" do
    @tag :skip # Takes ~20 seconds on my hw
    test "crack for abc" do
      assert crack("abc", &first_door/1) == "18f47a30"
    end
  end

  describe "second door" do
    @tag :skip # Takes ~35 seconds om my hw
    test "crack for abc" do
      assert crack("abc", &second_door/1) == "05ace8e3"
    end
  end
end
