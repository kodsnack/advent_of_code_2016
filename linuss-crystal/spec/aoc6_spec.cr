require "./spec_helper"

AOC6_INPUT = <<-EOS
  eedadn
  drvtee
  eandsr
  raavrd
  atevrs
  tsrnev
  sdttsa
  rasrtv
  nssdts
  ntnada
  svetve
  tesnvt
  vntsnd
  vrdear
  dvrsen
  enarar
  EOS

describe AoC6 do
  it "works" do
    AoC6.new(AOC6_INPUT).repetitions do |size|
      size
    end.should eq "easter"

    AoC6.new(AOC6_INPUT).repetitions do |size|
      -size
    end.should eq "advent"
  end
end
