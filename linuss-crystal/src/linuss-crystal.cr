require "./linuss-crystal/*"
require "./*"
require "option_parser"

OptionParser.parse! do |parser|
  parser.unknown_args { puts parser }
  parser.invalid_option { puts parser }

  parser.banner = "Usage: -daynumber [args]"
  parser.on("-1 FNAME", "Day 1: provide filename") { |name| puts AoC1.bunny_distance(name) }
  parser.on("-2 FNAME", "Day 2: provide filename") { |name| puts AoC2.new.process(File.read name).join }

  parser.on("-h", "--help", "Show this help") { puts parser }
end
