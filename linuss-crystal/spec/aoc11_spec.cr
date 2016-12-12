require "./spec_helper"

AOC11_INPUT = <<-EOS
The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
EOS

Microchip = AoC11::Microchip
Generator = AoC11::Generator

describe AoC11 do
  it "parses the input" do
    machine = AoC11.new(AOC11_INPUT)
    machine.state.floors[0].contents.should contain(Microchip.new "hydrogen")
    machine.state.floors[2].contents.should contain(Generator.new "lithium")
    machine.state.hash.should eq({
      "e"   => 0,
      "0 0" => 1,
      "0 1" => 2,
    })
  end

  it "recognizes valid floors" do
    floor = AoC11::Floor.new
    floor.valid?.should be_true

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.valid?.should be_true

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Generator.new "x")
    floor.valid?.should be_true

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Microchip.new "y")
    floor.valid?.should be_true

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Generator.new "y")
    floor.valid?.should be_false

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Microchip.new "y")
    floor.add(Generator.new "x")
    floor.valid?.should be_false

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Generator.new "y")
    floor.add(Generator.new "x")
    floor.valid?.should be_true

    floor = AoC11::Floor.new
    floor.add(Microchip.new "x")
    floor.add(Microchip.new "y")
    floor.add(Generator.new "x")
    floor.add(Generator.new "y")
    floor.valid?.should be_true
  end

  it "finds the path" do
    machine = AoC11.new(AOC11_INPUT)
    machine.search.should eq 11
    machine.print
  end
end
