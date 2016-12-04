alias Advent.SecurityThroughObscurity, as: Advent04
[path] = System.argv
input = File.read!(path)

valid_rooms = input
  |> Advent04.rooms
  |> Enum.filter(&Advent04.valid_room?/1)

sum_of_sector_ids = valid_rooms
  |> Enum.map(& &1.sector_id)
  |> Enum.sum
IO.puts "Part 1: The sum of sector ids of real rooms are: #{sum_of_sector_ids}"

northpole_object_storage = valid_rooms
  |> Enum.find(& Advent04.decrypt(&1) |> String.contains?("northpole object"))
IO.puts "Part 2: The sector ID of the northpole object storage room is: #{northpole_object_storage.sector_id}"
