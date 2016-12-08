require "./spec_helper"

describe AoC8 do
  it "#rect" do
    display = AoC8.new
    display.rect(3, 2)
    display.count.should eq 6
    display[0, 0].on.should eq true
    display[2, 1].on.should eq true
    display[3, 2].on.should eq false
  end

  it "#rotate_column" do
    display = AoC8.new
    display.rect(3, 2)
    display.rotate_column(1, 2)
    display[1, 0].on.should eq false
    display[1, 1].on.should eq false
    display[1, 2].on.should eq true
    display[1, 3].on.should eq true
    display[1, 4].on.should eq false
    display.count.should eq 6
    display.display.size.should eq AoC8::WIDTH
    display.display[1].size.should eq AoC8::HEIGHT
  end

  it "#rotate_row" do
    display = AoC8.new
    display.rect(2, 2)
    display.rotate_row(1, 2)
    display[0, 1].on.should eq false
    display[1, 1].on.should eq false
    display[2, 1].on.should eq true
    display[3, 1].on.should eq true
    display[4, 1].on.should eq false
    display.count.should eq 4
    display.display[1].size.should eq AoC8::HEIGHT
  end

  it "reads input" do
    instructions = <<-EOS
    rect 3x2
    rotate row y=0 by 1
    rotate column x=1 by 1
    rect 3x2
    EOS
    AoC8.process(instructions).count.should eq 8
  end
end
