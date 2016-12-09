require "./spec_helper"

describe AoC9 do
  it "decompresses" do
    AoC9.new("ADVENT").decompress.should eq "ADVENT"
    AoC9.new("A(1x5)BC").decompress.should eq "ABBBBBC"
    AoC9.new("(3x3)XYZ").decompress.should eq "XYZXYZXYZ"
    AoC9.new("A(2x2)BCD(2x2)EFG").decompress.should eq "ABCBCDEFEFG"
    AoC9.new("(6x1)(1x3)A").decompress.should eq "(1x3)A"
    AoC9.new("X(8x2)(3x3)ABCY").decompress.should eq "X(3x3)ABC(3x3)ABCY"
  end

  it "decompressv2" do
    AoC9.new("(3x3)XYZ").decompressv2.should eq 9
    AoC9.new("X(8x2)(3x3)ABCY").decompressv2.should eq 20
    AoC9.new("(27x12)(20x12)(13x14)(7x10)(1x12)A").decompressv2.should eq 241920
    AoC9.new("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN").decompressv2.should eq 445
  end
end
