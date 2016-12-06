alias Advent.SignalsAndNoise, as: Advent06
[path] = System.argv
input = File.read!(path)

IO.puts "Part 1: The error corrected message is: " <> Advent06.error_correct_by_most_frequent(input)
IO.puts "Part 2: The error corrected message is: " <> Advent06.error_correct_by_least_frequent(input)
