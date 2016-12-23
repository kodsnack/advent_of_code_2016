require "./spec_helper"

AOC12_INPUT = <<-EOS
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
EOS

AOC23_INPUT = <<-EOS
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
EOS

AOC23_OPT = <<-EOS
cpy 5 a
inc b
dec a
jnz a -2
EOS

AOC23_OPT2 = <<-EOS
cpy 6 d
cpy 3 b
cpy b c
add c a
nop
nop
dec d
jnz d -5
EOS

describe AoC12 do
  it "processes" do
    machine = AoC12.new(AOC12_INPUT)
    machine.process!
    machine.registers["a"].should eq 42
  end

  describe "aoc23" do
    it "processes" do
      machine = AoC12.new(AOC23_INPUT)
      machine.process!
      machine.registers["a"].should eq 3
    end

    it "optimizes" do
      machine = AoC12.new(AOC23_OPT)
      machine.instructions.should eq ["cpy", "add", "nop", "nop"]
      machine.process!
      machine.registers["b"].should eq 5
    end
  end
end
