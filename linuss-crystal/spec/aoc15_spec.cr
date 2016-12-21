require "./spec_helper"

AOC15INPUT = <<-EOS
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
EOS

describe AoC15 do
  it "b" do
    d = AoC15::Disc.new(5i64, 2i64)
    m = 440895i64
    ((d.b(m) * (m / 5)) % 5).should eq 1
  end

  it "works" do
    AoC15.new(AOC15INPUT).discs.size.should eq 2
    AoC15.new(AOC15INPUT).calculate.should eq 5
  end
end
