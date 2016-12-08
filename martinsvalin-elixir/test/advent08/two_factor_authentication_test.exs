defmodule Advent.TwoFactorAuthenticationTest do
  use ExUnit.Case
  import Advent.TwoFactorAuthentication
  alias Advent.Screen
  doctest Advent.TwoFactorAuthentication

  @blank_7x3 Screen.new """
             .......
             .......
             .......
             """

  describe "draw" do
    @instructions [
      "rect 3x2",
      "rotate column x=1 by 1",
      "rotate row y=0 by 4",
      "rotate column x=1 by 1"
    ]

    test "no instructions gives a blank screen" do
      assert draw([], @blank_7x3).screen ==
        """
        .......
        .......
        .......
        """
    end

    test "light up 3x2 in the top corner" do
      assert draw(Enum.take(@instructions, 1), @blank_7x3).screen ==
        """
        ###....
        ###....
        .......
        """
    end

    test "rotate column 1 down by 1" do
      assert draw(Enum.take(@instructions, 2), @blank_7x3).screen ==
        """
        #.#....
        ###....
        .#.....
        """
    end

    test "rotate first row right 4" do
      assert draw(Enum.take(@instructions, 3), @blank_7x3).screen ==
        """
        ....#.#
        ###....
        .#.....
        """
    end

    test "rotate column 1 down 3, so it wraps" do
      assert draw(@instructions, @blank_7x3).screen ==
        """
        .#..#.#
        #.#....
        .#.....
        """
    end
  end


  describe "light_up_rectangle" do
    test "light 3x2" do
      assert light_up_rectangle(@blank_7x3, 3, 2) ==
        Screen.new("""
        ###....
        ###....
        .......
        """)
    end
  end
end
