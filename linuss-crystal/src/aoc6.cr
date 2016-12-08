class AoC6
  def self.process(fname)
    new(File.read(fname)).repetitions do |size|
      size
    end
  end

  def self.process_least(fname)
    new(File.read(fname)).repetitions do |size|
      -size
    end
  end

  property input : String

  def initialize(@input)
  end

  def repetitions(&block : Int32 -> Int32)
    columns(matrix).map do |column|
      sorted_by_char(column, &block)
    end.map do |(_size, char)|
      char
    end.join
  end

  def matrix
    input.each_line.map(&.chomp).map(&.chars).to_a
  end

  def columns(matrix)
    matrix.first.size.times.map do |col_i|
      matrix.map { |row| row[col_i] }
    end
  end

  def sorted_by_char(column, &block : Int32 -> Int32)
    column.group_by(&.itself).map do |char, list|
      {list.size, char}
    end.sort_by do |(size, _char)|
      block.call size
    end[-1]
  end
end
