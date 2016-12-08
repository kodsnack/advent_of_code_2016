defmodule Advent.Screen do
  defstruct dimensions: {0,0}, screen: ""

  def new(string) when is_binary(string) do
    rows = String.split(string, "\n", trim: true)
    dimensions = {byte_size(hd rows), length rows}
    %__MODULE__{dimensions: dimensions, screen: string}
  end
  def new({x,y} = dimensions) when is_integer(x) and is_integer(y) do
    string = String.duplicate(".", x) |> List.duplicate(y) |> Enum.join("\n")
    %__MODULE__{dimensions: dimensions, screen: string}
  end
end

defimpl String.Chars, for: Advent.Screen do
  def to_string(screen), do: screen.screen
end

defmodule Advent.TwoFactorAuthentication do
  @moduledoc """
  # Advent of Code, Day 8: Two-Factor Authentication

  See: http://adventofcode.com/2016/day/8
  """

  alias Advent.Screen
  @typep screen :: %Screen{}

  @doc """
  Draw the screen from the instructions
  """
  @spec draw([String.t], screen) :: screen
  def draw(instructions, screen) do
    Enum.reduce(instructions, screen, &perform_instruction/2)
  end


  @spec count_lit_pixels(screen) :: integer
  def count_lit_pixels(screen) do
    screen.screen |> String.codepoints |> Enum.count(& &1 == "#")
  end

  @doc """
  Perform one instruction on a screen
  """
  @spec perform_instruction(String.t, screen) :: screen
  def perform_instruction("rect " <> dimensions, screen) do
    [width, height] = dimensions |> String.split("x") |> Enum.map(&String.to_integer/1)
    light_up_rectangle(screen, width, height)
  end
  def perform_instruction("rotate column x=" <> rotation, screen) do
    [x, by_n] = rotation |> String.split(" by ") |> Enum.map(&String.to_integer/1)
    rotate_column(screen, x, by_n)
  end
  def perform_instruction("rotate row y=" <> rotation, screen) do
    [y, by_n] = rotation |> String.split(" by ") |> Enum.map(&String.to_integer/1)
    rotate_row(screen, y, by_n)
  end
  def perform_instruction(_, screen), do: screen


  @doc """
  Light up pixels in the top-left rectangle given by height and width
  """
  @spec light_up_rectangle(screen, integer, integer) :: screen
  def light_up_rectangle(screen, width, height) do
    pixels = for x <- 1..width, y <- 1..height, do: {x-1, y-1}
    Enum.reduce(pixels, screen, &turn_on_pixel/2)
  end


  @spec rotate_column(screen, integer, integer) :: screen
  def rotate_column(%Screen{dimensions: {_, height}} = screen, x, by_n) do
    pixels = for y <- 1..height, do: {x, y-1}
    values = Enum.map(pixels, &read_pixel_at(screen, &1))
    new_values = rotate(values, by_n)

    Enum.zip(pixels, new_values)
    |> Enum.reduce(screen, fn {pixel, value}, acc -> write_pixel_at(acc, pixel, value) end)
  end


  @spec rotate_row(screen, integer, integer) :: screen
  def rotate_row(%Screen{dimensions: {width, _}} = screen, y, by_n) do
    pixels = for x <- 1..width, do: {x-1, y}
    values = Enum.map(pixels, &read_pixel_at(screen, &1))
    new_values = rotate(values, by_n)

    Enum.zip(pixels, new_values)
    |> Enum.reduce(screen, fn {pixel, value}, acc -> write_pixel_at(acc, pixel, value) end)
  end


  @spec turn_on_pixel(screen, {integer, integer}) :: screen
  def turn_on_pixel(pixel, screen), do: write_pixel_at(screen, pixel, "#")


  @spec write_pixel_at(screen, {integer, integer}, String.t) :: screen
  def write_pixel_at(%Screen{dimensions: {width, _}, screen: string}, {x, y}, new_value) do
    index = y * (width + 1) + x # + 1 for the new line characters
    <<left :: binary-size(index), _overwritten, right :: binary>> = string
    Screen.new(left <> new_value <> right)
  end


  @spec read_pixel_at(screen, {integer, integer}) :: screen
  def read_pixel_at(%Screen{dimensions: {width, _}, screen: string}, {x, y}) do
    index = y * (width + 1) + x
    String.at(string, index)
  end


  @doc """
  Rotate a list to the right

  ## Examples

      iex> rotate([1, 2, 3, 4, 5], 2)
      [4, 5, 1, 2, 3]
  """
  @spec rotate([any], integer) :: [any]
  def rotate(list, by_n) do
    by_n = rem(by_n, length(list))
    {left, right} = Enum.reverse(list) |> Enum.split(by_n)
    Enum.reverse(left) ++ Enum.reverse(right)
  end
end
