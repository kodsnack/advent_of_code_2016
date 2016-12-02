alias Advent.NoTimeForTaxicab, as: Advent01

path = case System.argv do
  [] -> "#{__DIR__}/input.txt"
  [file] -> file
end
positions = File.read!(path) |> Advent01.follow_instructions

part1_distance = Advent01.distance_from_start(hd positions)
IO.puts "Part 1: The distance to HQ is #{part1_distance}"

part2_distance = positions
  |> Enum.reverse
  |> Advent01.first_visited_twice
  |> Advent01.distance_from_start
IO.puts "Part 2: The distance to the first location visited twice is #{part2_distance}"
