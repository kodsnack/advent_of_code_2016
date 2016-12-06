alias Advent.HowAboutANiceGameOfChess, as: Advent05
[path] = System.argv
input = File.read!(path) |> String.strip

first_door_pw = Advent05.crack(input, &Advent05.first_door/1)
IO.puts "Part 1: The password for the first door is: #{first_door_pw}"

second_door_pw = Advent05.crack(input, &Advent05.second_door/1)
IO.puts "Part 2: The password for the second door is: #{second_door_pw}"
