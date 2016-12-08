require "./spec_helper"

describe AoC5 do
  it "hashes" do
    AoC5.new("abc").hash(3231929)[0..4].should eq "00000"
  end

  it "finds passwords" do
    AoC5.new("abc").find_password.should eq "18f47a30"
  end

  it "finds chars with positions" do
    aoc = AoC5.new("abc")
    aoc.char_with_pos(aoc.hash(3231929)).should eq({1, '5'})
    aoc.char_with_pos(aoc.hash(5357525)).should eq({4, 'e'})
  end

  it "finds improved passwords" do
    AoC5.new("abc").find_improved_password.should eq "05ace8e3"
  end
end
