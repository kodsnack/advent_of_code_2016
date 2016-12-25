require "./spec_helper"

AOC24_INPUT = <<-EOS
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
EOS

describe AoC24 do
  it "finds pairwise connections" do
    map = AoC24.new(AOC24_INPUT)

    map.points.size.should eq 5
  end

  it "has neighbours" do
    map = AoC24.new(AOC24_INPUT)

    map.neighbours(map.points.keys.first).size.should eq 2
  end

  it "finds pairwise connections" do
    map = AoC24.new(AOC24_INPUT)
    map.pointwise.values.flatten.size.should eq 20
  end

  it "finds shortest" do
    map = AoC24.new(AOC24_INPUT)
    map.shortest.should eq 14
    map.shortest(reset: true).should eq 20
  end
end
