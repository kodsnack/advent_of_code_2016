require "./spec_helper"

describe AoC13 do
  it "finds the way" do
    AoC13.new("10").search({7, 4}).should eq 11
  end

  it "gets the neighbours of {1,1} right" do
    AoC13.new("10").neighbours({1, 1}).should eq [{1, 2}, {0, 1}]
  end
end
