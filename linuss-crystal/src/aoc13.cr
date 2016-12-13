class AoC13
  alias Pos = Tuple(Int32, Int32)
  alias State = NamedTuple(pos: Pos, move: Int32)
  alias MapPos = Hash(Pos, Char)
  STARTING_POS = {1, 1}

  property seed : Int32
  property map

  def initialize(input)
    @map = MapPos.new
    @seed = input.to_i
  end

  def print_maze(size, target_pos, parents)
    visited = Set.new([target_pos])
    while parents[target_pos]?
      target_pos = parents[target_pos]
      visited << target_pos
    end
    map = (0..size - 1).map do |y|
      (0..size - 1).map do |x|
        pos = {x, y}
        free_space?(pos)
        if visited.includes? pos
          if @map[pos] == '#'
            'X' # FAIL
          else
            'O'
          end
        else
          @map[pos]
        end
      end.join
    end.join('\n')
    puts map
  end

  def search(target)
    queue = Deque(State).new
    seen = Set(Pos).new
    parents = Hash(Pos, Pos).new

    current = {pos: STARTING_POS, move: 0}
    seen << STARTING_POS
    queue << current
    while current[:pos] != target && (current = queue.shift)
      neighbours(current[:pos]).each do |pos|
        unless seen.includes?(pos)
          queue << {pos: pos, move: current[:move] + 1}
          seen << pos
          parents[pos] = current[:pos]
        end
      end
    end
    print_maze(50, current[:pos], parents)

    current[:move]
  end

  def reachable_in(steps)
    queue = Deque(State).new
    seen = Set(Pos).new

    current = {pos: STARTING_POS, move: 0}
    seen << STARTING_POS
    queue << current
    while (current = queue.shift) && current[:move] < steps
      neighbours(current[:pos]).each do |pos|
        unless seen.includes?(pos)
          queue << {pos: pos, move: current[:move] + 1}
          seen << pos
        end
      end
    end
    seen.size
  end

  def free_space?(pos)
    return @map[pos] == '.' if @map[pos]?
    x, y = pos
    value = x*x + 3*x + 2*x*y + y + y*y
    free = (value + @seed).popcount.even?
    @map[pos] = free ? '.' : '#'
    free
  end

  def neighbours(pos)
    x, y = pos
    [{1, 0}, {0, 1}, {-1, 0}, {0, -1}].map do |x1, y1|
      {x + x1, y + y1}
    end.reject do |x, y|
      x < 0 || y < 0
    end.select { |pos| free_space?(pos) }
  end
end
