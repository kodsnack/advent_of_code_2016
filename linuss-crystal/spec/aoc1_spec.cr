require "./spec_helper"

describe AoC1 do
  it "handles basic cases" do
    AoC1.calculate_bunny_distance("").should eq 0
    AoC1.calculate_bunny_distance("R1").should eq 1
    AoC1.calculate_bunny_distance("L1").should eq 1
    AoC1.calculate_bunny_distance("R1, R1").should eq 2
  end

  it "handles examples from description" do
    AoC1.calculate_bunny_distance("R2, L3").should eq 5
    AoC1.calculate_bunny_distance("R2, R2, R2").should eq 2
    AoC1.calculate_bunny_distance("R5, L5, R5, R3").should eq 12
  end

  it "can read files with instructions" do
    AoC1.bunny_distance("spec/aoc1_example.txt").should eq 4
  end
end
