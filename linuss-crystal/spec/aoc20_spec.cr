require "./spec_helper"

AOC20_INPUT = <<-EOS
5-8
0-2
4-7
EOS

describe AoC20 do
  it "blacklists" do
    valid = [3, 9]
    invalid = (0..9).to_a - valid
    valid.each { |v| AoC20.new(AOC20_INPUT).blacklisted?(v).should be_falsey }
    invalid.each { |v| AoC20.new(AOC20_INPUT).blacklisted?(v).should be_truthy }
  end

  it "finds non-blacklisted" do
    AoC20.new(AOC20_INPUT).find.should eq 3
    AoC20.new(AOC20_INPUT).count(9).should eq 2
  end
end
