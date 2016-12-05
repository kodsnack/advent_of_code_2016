require "./spec_helper"

def aoc2_test_string
  <<-EOS
    ULL
    RRDDD
    LURDL
    UUUUD
    EOS
end

describe AoC2 do
  it "empty case" do
    AoC2.new.position.should eq 5
  end

  it "goes in directions" do
    aoc = AoC2.new
    aoc.goto('U').should eq 2
    aoc.goto('U').should eq 2
    aoc.goto('L').should eq 1
    aoc.goto('L').should eq 1
    aoc.goto('D').should eq 4
    aoc.goto('D').should eq 7
    aoc.goto('D').should eq 7
    aoc.goto('R').should eq 8
    aoc.goto('R').should eq 9
    aoc.goto('R').should eq 9
  end

  it "handles single rows" do
    aoc = AoC2.new
    aoc.process ['L', 'L']
    aoc.position.should eq 4

    aoc = AoC2.new
    aoc.process ['R']
    aoc.position.should eq 6

    aoc = AoC2.new
    aoc.process ['L', 'U', 'R', 'R']
    aoc.position.should eq 3
  end

  it "gives positions for multiple rows" do
    AoC2.new.process([['L']]).should eq [4]
    AoC2.new.process([['L'], ['U']]).should eq [4, 1]
  end

  it "handles string input" do
    AoC2.new.process(aoc2_test_string).should eq([1, 9, 8, 5])
  end
end

describe AoC2 do
  it "empty case" do
    AoC2b.new.position.should eq 5
  end

  it "examples" do
    AoC2b.new.process(aoc2_test_string).should eq([5, 'D', 'B', 3])
  end
end
