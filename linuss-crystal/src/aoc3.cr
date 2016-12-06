class AoC3
  alias Triangle = Array(Int32)
  property triangles : Array(Triangle)

  def self.count_by_row(fname)
    new.by_row(File.read fname).count_valid_triangles
  end

  def self.count_by_column(fname)
    new.by_column(File.read fname).count_valid_triangles
  end

  def initialize
    @triangles = Array(Triangle).new
  end

  def read_values(string)
    rows = string.lines.map(&.chomp)
    rows.map { |row| row.split.map &.to_i }
  end

  def by_row(string)
    @triangles = read_values(string)
    self
  end

  def by_column(string)
    values = read_values(string)
    values.in_groups_of(3, [0, 0, 0]) do |(row1, row2, row3)|
      3.times do |i|
        triangles << [row1[i], row2[i], row3[i]]
      end
    end
    self
  end

  def count_valid_triangles
    triangles.map { |triangle| valid_triangle?(triangle) ? 1 : 0 }.sum
  end

  def valid_triangle?(numbers : Triangle)
    sorted = numbers.sort
    sorted[0] + sorted[1] > sorted[2]
  end
end
