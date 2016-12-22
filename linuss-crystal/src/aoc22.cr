class AoC22
  record(Node, name : String, x : Int32, y : Int32, size : Int32, used : Int32, avail : Int32)
  alias Pos = Tuple(Int32, Int32)
  alias State = Tuple(Pos, Pos)

  property nodes : Array(Node)
  property blocked : Set(Pos)
  property starting_state : State
  property max_x : Int32
  property max_y : Int32

  def self.count_viable(fname)
    new(File.read fname).viable_pairs.size
  end

  def self.search(fname)
    new(File.read fname).search
  end

  def initialize(input)
    @nodes = parse(input.lines)
    @max_x = nodes.max_by(&.x).x || -1
    @max_y = nodes.max_by(&.y).y || -1
    @blocked, @starting_state = build_start_map
  end

  def search
    seen = Set(State).new
    queue = Deque(Tuple(State, Int32)).new
    seen << starting_state
    queue << {starting_state, 0}
    while !queue.empty?
      current, moves = queue.shift
      return moves if current[1] == {0, 0}
      neighbours(current).reject { |n| seen.includes? n }.each do |n|
        queue << {n, moves + 1}
        seen << n
      end
    end
    return -1
  end

  def build_start_map
    empty = {-1, -1}
    goal = {max_x, 0}
    blocked = Set(Pos).new
    if nodes.any?
      average = nodes.sum(&.size) / nodes.size
      nodes.each do |node|
        if node.used == 0
          empty = {node.x, node.y}
        elsif node.size < average * 2
        else
          blocked << {node.x, node.y}
        end
      end
    end
    {blocked, {empty, goal}}
  end

  def emit_map(state)
    empty, goal = state
    (max_y + 1).times.map do |y|
      (max_x + 1).times.map do |x|
        pos = {x, y}
        if blocked.includes?(pos)
          '#'
        elsif pos == empty
          '_'
        elsif pos == goal
          'G'
        else
          '.'
        end
      end.join
    end.join('\n')
  end

  def parse(lines)
    lines[1..-1].compact_map do |line|
      if match = /\/dev\/grid\/(?<name>node-x(?<x>\d+)-y(?<y>\d+))\W+(?<size>\d+)T\W+(?<used>\d+)T\W+(?<avail>\d+)T\W+(?<use>\d+)%/.match(line)
        Node.new(match["name"], match["x"].to_i, match["y"].to_i, match["size"].to_i, match["used"].to_i, match["avail"].to_i)
      end
    end
  end

  def viable_pairs
    nodes.product(nodes).reject do |(n1, n2)|
      n1.name == n2.name || n1.used == 0 || n2.avail < n1.used
    end
  end

  def neighbours(state)
    empty, goal = state
    [{1, 0}, {0, 1}, {-1, 0}, {0, -1}].map do |(x, y)|
      {empty[0] + x, empty[1] + y}
    end.select { |x, y| 0 <= x <= max_x && 0 <= y <= max_y }.reject do |pos|
      blocked.includes?(pos)
    end.map { |pos| pos == goal ? {pos, empty} : {pos, goal} }
  end
end
