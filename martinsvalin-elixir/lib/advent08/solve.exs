alias Advent.TwoFactorAuthentication, as: Advent08
alias Advent.Screen
[path] = System.argv
input = File.read!(path)

output = input
|> String.split("\n")
|> Advent08.draw(Screen.new({50, 6}))

IO.puts output.screen
pixel_count = Advent08.count_lit_pixels(output)

IO.puts "Part 1: There should be #{pixel_count} pixels lit on the screen."
