class AoC2
  alias Row = Array(Char)
  alias Instructions = Array(Row)

  property position : Int32

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
                  [1, 2, 3].includes?(position) ? position : position - 3
                when 'D'
                  [7, 8, 9].includes?(position) ? position : position + 3
                when 'L'
                  [1, 4, 7].includes?(position) ? position : position - 1
                when 'R'
                  [3, 6, 9].includes?(position) ? position : position + 1
                else
                  raise "Unknown direction '#{direction}'"
                end
  end
end
