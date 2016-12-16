require "./spec_helper"

describe AoC16 do
  it "generates correctly" do
    AoC16.new("1").inflate.should eq "100".chars
    AoC16.new("0").inflate.should eq "001".chars
    AoC16.new("11111").inflate.should eq "11111000000".chars
    AoC16.new("111100001010").inflate.should eq "1111000010100101011110000".chars
  end

  it "#checksum" do
    AoC16.new("").checksum("110010110100".chars).should eq "100".chars
  end

  it "#generate" do
    AoC16.new("10000").generate(20).should eq "01100".chars
  end
end
