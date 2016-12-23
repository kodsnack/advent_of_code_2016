require "./spec_helper"

AOC22_INPUT = <<-EOS
Filesystem
/dev/grid/node-x0-y0     85T   69T    16T   81%
/dev/grid/node-x0-y1     89T   66T    23T   74%
/dev/grid/node-x0-y2     92T   69T    23T   75%
/dev/grid/node-x0-y3     85T   72T    13T   84%
/dev/grid/node-x0-y4     94T   73T    21T   77%
EOS

AOC22B_INPUT = <<-EOS
Filesystem            Size  Used  Avail  Use%
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T   28T     4T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    0T     8T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
EOS

describe AoC22 do
  it "parses" do
    AoC22.new(AOC22_INPUT).nodes.should eq [
      AoC22::Node.new("node-x0-y0", 0, 0, 85, 69, 16),
      AoC22::Node.new("node-x0-y1", 0, 1, 89, 66, 23),
      AoC22::Node.new("node-x0-y2", 0, 2, 92, 69, 23),
      AoC22::Node.new("node-x0-y3", 0, 3, 85, 72, 13),
      AoC22::Node.new("node-x0-y4", 0, 4, 94, 73, 21),
    ]
  end

  it "finds viable pairs" do
    aoc = AoC22.new("\n")
    n1 = AoC22::Node.new("node-x0-y1", 0, 0, 0, 66, 23)
    n2 = AoC22::Node.new("node-x0-y2", 0, 0, 0, 22, 23)
    n3 = AoC22::Node.new("node-x0-y3", 0, 0, 0, 10, 13)
    aoc.nodes = [n1, n2, n3]

    aoc.viable_pairs.should eq [
      {n2, n1},
      {n3, n1},
      {n3, n2},
    ]
  end

  it "generates map" do
    aoc = AoC22.new(AOC22B_INPUT)
    aoc.emit_map(aoc.starting_state).should eq <<-EOS
    ..G
    ._.
    #..
    EOS
  end
end
