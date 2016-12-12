require "./spec_helper"

AoC10INPUT = <<-EOS
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
EOS

describe AoC10 do
  it "parses input" do
    machine = AoC10.new(AoC10INPUT)
    machine.bot(2).values.should eq [5, 2]
  end

  it "processes" do
    machine = AoC10.new(AoC10INPUT)
    machine.process!
    machine.output(0).value.should eq 5
    machine.output(1).value.should eq 2
    machine.output(2).value.should eq 3
  end
end
