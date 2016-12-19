require "./spec_helper"

describe AoC19 do
  it "collects presents" do
    AoC19.new(5).steal.should eq 3
  end

  it "collects presents from opposite" do
    AoC19.new(5).steal_opposite.should eq 2
  end
end
