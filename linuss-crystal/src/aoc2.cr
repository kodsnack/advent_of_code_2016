class AoC2
  alias Row = Array(Char)
  alias Instructions = Array(Row)

  property position : Int32 | Char

  def initialize
    @position = 5
  end

  def process(contents)
    rows = contents.lines.map(&.chomp)
    instructions = rows.map(&.chars)
    process(instructions)
  end

  def process(instructions : Instructions)
    instructions.map { |row| process row }
  end

  def process(row : Row)
    row.each { |dir| goto dir }
    position
  end

  def goto(direction)
    @position = case direction
                when 'U'
                  up
                when 'D'
                  down
                when 'L'
                  left
                when 'R'
                  right
                else
                  raise "Unknown direction '#{direction}'"
                end
  end

  def up
    [1, 2, 3].includes?(position) ? position : position - 3
  end

  def down
    [7, 8, 9].includes?(position) ? position : position + 3
  end

  def left
    [1, 4, 7].includes?(position) ? position : position - 1
  end

  def right
    [3, 6, 9].includes?(position) ? position : position + 1
  end
end

class AoC2b < AoC2
  def identity
    {
        1 => 1,
        2 => 2,
        3 => 3,
        4 => 4,
        5 => 5,
        6 => 6,
        7 => 7,
        8 => 8,
        9 => 9,
      'A' => 'A',
      'B' => 'B',
      'C' => 'C',
      'D' => 'D',
    }
  end

  def lookup(keys)
    identity.merge(keys).fetch(position)
  end

  def up
    lookup({
        3 => 1,
        6 => 2,
        7 => 3,
        8 => 4,
      'A' => 6,
      'B' => 7,
      'C' => 8,
      'D' => 'B',
    })
  end

  def down
    lookup({
        1 => 3,
        2 => 6,
        3 => 7,
        4 => 8,
        6 => 'A',
        7 => 'B',
        8 => 'C',
      'B' => 'D',
    })
  end

  def left
    lookup({
        3 => 2,
        4 => 3,
        6 => 5,
        7 => 6,
        8 => 7,
        9 => 8,
      'B' => 'A',
      'C' => 'B',
    })
  end

  def right
    lookup({
        2 => 3,
        3 => 4,
        5 => 6,
        6 => 7,
        7 => 8,
        8 => 9,
      'A' => 'B',
      'B' => 'C',
    })
  end
end
