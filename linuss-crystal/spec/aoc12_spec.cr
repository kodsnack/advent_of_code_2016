require "./spec_helper"
AOC12_INPUT = <<-EOS
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
EOS

describe AoC12 do
  it "processes" do
    machine = AoC12.new(AOC12_INPUT)
    machine.process!
    machine.registers["a"].should eq 42
  end
end
