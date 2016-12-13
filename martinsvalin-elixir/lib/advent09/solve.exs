alias Advent.ExplosivesInCyberspace, as: Advent09
[path] = System.argv
input = File.read!(path) |> String.strip

IO.puts "Part 1: The uncompressed file size for version 1 is: #{Advent09.uncompressed_size(input)}"
IO.puts "Part 2: The uncompressed file size for version 2 is: #{Advent09.uncompressed_size(input, :v2)}"
