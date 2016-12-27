class AoC24
  alias Pos = Tuple(Int32, Int32)
  alias PointMove = Tuple(Int32, Int32)

  property walls : Hash(Pos, Bool)
  property points : Hash(Pos, Int32)
  property pointwise : Hash(Int32, Array(PointMove))

  def self.find_shortest(fname)
    new(File.read fname).shortest
  end

  def self.find_shortest_and_return(fname)
    new(File.read fname).shortest(reset: true)
  end

  def initialize(map)
    @walls, @points = parse(map)
    @pointwise = calculate_connections
  end

  def shortest(reset = false)
    queue = Array(Tuple(Int32, Int32, Array(Int32))).new
    queue << {0, 0, [0]}
    while !queue.empty?
      current, move, seen = queue.shift

      return move if !reset && seen.size == points.size
      if reset && seen.size == points.size + 1
        return move
      end

      pointwise[current].each do |p, n|
        queue << {p, move + n, seen + [p]} unless seen.includes?(p)
      end
      if reset && seen.size == points.size
        pm = pointwise[current].find { |(p, _)| p == 0 }
        if pm
          _, m = pm
          queue << {0, move + m, seen + [0]}
        end
      end

      queue.sort_by! &.[1]
    end
    raise "Not found"
  end

  def parse(map)
    walls = Hash(Pos, Bool).new
    points = Hash(Pos, Int32).new

    map.lines.each_with_index do |line, i|
      line.chars.each_with_index do |tile, j|
        case tile
        when '#'
          walls[{i, j}] = true
        when '.'
        else
          points[{i, j}] = tile.to_i
        end
      end
    end

    {walls, points}
  end

  def neighbours(pos : Pos)
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}].map do |(x, y)|
      {pos[0] + x, pos[1] + y}
    end.reject { |p| walls[p]? }
  end

  def calculate_connections
    connections = Hash(Int32, Array(PointMove)).new
    points.each do |pos, point|
      conns = [] of PointMove
      seen = Set(Pos).new
      seen << pos
      queue = Deque(Tuple(Pos, Int32)).new
      queue << {pos, 0}
      while !queue.empty?
        current, move = queue.shift
        if points[current]?
          conns << {points[current], move} if current != pos
          break if conns.size > points.size - 2
        end
        neighbours(current).each do |n|
          queue << {n, move + 1} unless seen.includes?(n)
          seen << n
        end
      end
      connections[point] = conns
    end
    connections
  end
end
