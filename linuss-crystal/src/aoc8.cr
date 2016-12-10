class AoC8
  record Pixel, on : Bool = false do
    def on!
      @on = true
    end

    def to_s
      on ? '*' : ' '
    end
  end

  WIDTH  = 50
  HEIGHT =  6

  alias Column = Array(Pixel)
  alias Display = Array(Column)

  property display : Display

  def self.process_file(fname)
    process(File.read fname)
  end

  def self.process(str)
    display = new
    str.lines.each do |line|
      case line
      when /rect (\d+)x(\d+)/
        display.rect($1.to_i, $2.to_i)
      when /rotate row y=(\d+) by (\d+)/
        display.rotate_row($1.to_i, $2.to_i)
      when /rotate column x=(\d+) by (\d+)/
        display.rotate_column($1.to_i, $2.to_i)
      end
    end
    display
  end

  def initialize
    @display = Display.new(WIDTH) { Column.new(HEIGHT) { Pixel.new } }
  end

  def rect(width, height)
    display[0, width].each { |col| col.fill(Pixel.new(on: true), 0, height) }
  end

  def rotate_column(idx, steps)
    display[idx] = rotate(display[idx], steps % HEIGHT)
  end

  def rotate_row(idx, steps)
    values = rotate(display.map(&.[idx]), steps % WIDTH)
    display.zip(values) { |col, value| col[idx] = value }
  end

  def rotate(array, steps)
    array[-steps..-1] + array[0..(-steps - 1)]
  end

  def count
    display.flatten.select(&.on).size
  end

  def [](row, column)
    display[row][column]
  end

  def []=(row, column, value)
    display[row][column] = value
  end

  def to_s
    (0..5).map do |i|
      display.map(&.[i]).map(&.to_s)
    end.map(&.join).join("\n")
  end
end
