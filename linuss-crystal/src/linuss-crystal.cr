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
  parser.on("--14 INPUT", "Day 14 INPUT") { |input| puts AoC14.new(input, AoC14::MD5Iterator).at(64) }
  parser.on("--14b INPUT", "Day 14b INPUT") { |input| puts AoC14.new(input, AoC14::StretchedMD5Iterator).at(64) }
  parser.on("--15 FILE", "Day 15 INPUT") { |name| puts AoC15.process name }
  parser.on("--15b FILE", "Day 15b INPUT") { |name| puts AoC15.process11 name }
  parser.on("--16 INPUT", "Day 16 INPUT") { |input| puts AoC16.new(input).generate(272) }
  parser.on("--16b INPUT", "Day 16b INPUT") { |input| puts AoC16.new(input).generate(35651584) }
  parser.on("--17 INPUT", "Day 17 INPUT") { |input| puts AoC17.new(input).search }
  parser.on("--17b INPUT", "Day 17b INPUT") { |input| puts AoC17.new(input).longest }
  parser.on("--18 INPUT", "Day 18 INPUT") { |input| puts AoC18.new.safe(input) }
  parser.on("--18b INPUT", "Day 18b INPUT") { |input| puts AoC18.new.safebig(input) }
  parser.on("--19 INPUT", "Day 19 INPUT") { |input| puts AoC19.new(input.to_i).steal }
  parser.on("--19b INPUT", "Day 19b INPUT") { |input| puts AoC19.new(input.to_i).steal_opposite }
  parser.on("--20 FILE", "Day 20 NAME") { |name| puts AoC20.find name }
  parser.on("--20b FILE", "Day 20b NAME") { |name| puts AoC20.count name }
  parser.on("--21 FILE", "Day 21 NAME") { |name| puts AoC21.new("abcdefgh").process(name) }
  parser.on("--21b FILE", "Day 21b NAME") { |name| puts AoC21.new("fbgdceah").unscramble(name) }
  parser.on("--22 FILE", "Day 22 NAME") { |name| puts AoC22.count_viable(name) }
  parser.on("--22b FILE", "Day 22b NAME") { |name| puts AoC22.search(name) }

  parser.on("-h", "--help", "Show this help") { puts parser }
end
