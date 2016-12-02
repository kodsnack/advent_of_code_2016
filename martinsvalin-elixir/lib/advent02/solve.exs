alias Advent.BathroomSecurity, as: Advent02

path = case System.argv do
  [] -> "#{__DIR__}/input.txt"
  [file] -> file
end

input = File.read!(path) |> String.trim

IO.puts "Part 1: The code for a 3x3 keypad is: " <>  Advent02.decode(input)
IO.puts "Part 2: The code for a star-shaped keypad is: " <> Advent02.decode(input, :star)
