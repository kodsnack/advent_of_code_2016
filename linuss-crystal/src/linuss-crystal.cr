require "./linuss-crystal/*"
require "./*"
require "option_parser"

OptionParser.parse! do |parser|
  parser.banner = "Usage: -daynumber [args]"
  parser.on("--1 FNAME", "Day 1: provide filename") { |name| puts AoC1.bunny_distance(name) }
  parser.on("--1b FNAME", "Day 1b: provide filename") { |name| puts AoC1.first_second(name) }
  parser.on("--2 FNAME", "Day 2a: provide filename") { |name| puts AoC2.new.process(File.read name).join }
  parser.on("--2b FNAME", "Day 2b: provide filename") { |name| puts AoC2b.new.process(File.read name).join }
  parser.on("--3 FNAME", "Day 3a: provide filename") { |name| puts AoC3.count_by_row name }
  parser.on("--3b FNAME", "Day 3b: provide filename") { |name| puts AoC3.count_by_column name }
  parser.on("--4 FNAME", "Day 4: provide filename") { |name| puts AoC4.process_file name }
  parser.on("--4b FNAME", "Day 4b: provide filename") { |name| puts AoC4.north_pole(name).not_nil!.sector }
  parser.on("--5 INPUT", "Day 5: provide input") { |input| puts AoC5.new(input).find_password }
  parser.on("--5b INPUT", "Day 5b: provide input") { |input| puts AoC5.new(input).find_improved_password }
  parser.on("--6 FILE", "Day 6: provide filename") { |name| puts AoC6.process name }
  parser.on("--6b FILE", "Day 6b: provide filename") { |name| puts AoC6.process_least name }
  parser.on("--7 FILE", "Day 7: provide filename") { |name| puts AoC7.count_tls name }
  parser.on("--7b FILE", "Day 7b: provide filename") { |name| puts AoC7.count_ssl name }
  parser.on("--8 FILE", "Day 8: provide filename") { |name| puts AoC8.process_file(name).count }
  parser.on("--8b FILE", "Day 8b: provide filename") { |name| puts AoC8.process_file(name).to_s }
  parser.on("--9 FILE", "Day 9: provide filename") { |name| puts AoC9.decompressed_size(name) }
  parser.on("--9b FILE", "Day 9b: provide filename") { |name| puts AoC9.decompressed_v2_size(name) }
  parser.on("--10 FILE", "Day 10a&b: provide filename") { |name| puts AoC10.compute(name) }
  parser.on("--11 FILE", "Day 11a: provide filename") { |name| puts AoC11.compute(name) }
  parser.on("--11b FILE", "Day 11b: provide filename") { |name| puts AoC11.computeb(name) }
  parser.on("--12 FILE", "Day 12: provide filename") { |name| puts AoC12.compute(name) }
  parser.on("--12b FILE", "Day 12b: provide filename") { |name| puts AoC12.computeb(name) }
  parser.on("--13", "Day 13") { puts AoC13.new("1362").search({31, 39}) }
  parser.on("--13b INPUT", "Day 13b INPUT") { |input| puts puts AoC13.new("1362").reachable_in(input.to_i) }

  parser.on("-h", "--help", "Show this help") { puts parser }
end
