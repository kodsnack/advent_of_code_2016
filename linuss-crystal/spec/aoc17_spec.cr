require "./spec_helper"

describe AoC17 do
  it "detects locked doors" do
    AoC17.new("hijkl").moves(Complex.new(0, 0), "").should eq [{Complex.new(1, 0), "D"}]
  end

  it "#search" do
    AoC17.new("hijkl").search.should be_nil
    AoC17.new("ihgpwlah").search.should eq "DDRRRD"
    AoC17.new("kglvqrro").search.should eq "DDUDRLRRUDRD"
    AoC17.new("ulqzkmiv").search.should eq "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  end
end
