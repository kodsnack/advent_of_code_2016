alias Advent.SquaresWithThreeSides, as: Advent03

[path] = System.argv
input = File.read!(path) |> String.trim

triangles_in_rows = Advent03.count_triangles(input, &Advent03.triplets_in_rows/1)
IO.puts "Part 1: The number of possible triangles, per row: #{triangles_in_rows}"

triangles_in_columns = Advent03.count_triangles(input, &Advent03.triplets_in_columns/1)
IO.puts "Part 2: The number of possible triangles, per column: #{triangles_in_columns}"
