class AoC4
  property name : String
  property raw_name : String
  property checksum
  property sector : Int32

  def self.process_file(name)
    valid_files(name).map(&.sector).sum
  end

  def self.valid_files(name)
    rooms = File.read(name).lines.map { |l| new l }
    rooms.select(&.valid?)
  end

  def self.north_pole(name)
    valid_files(name).find { |file| file.decoded_name =~ /northpole/i }
  end

  def initialize(full_name)
    parts = full_name.match(/(.*)-(\d+)\[(.*)\]/).not_nil!
    @raw_name = parts[1].as(String)
    @name = raw_name.delete('-')
    @sector = parts[2].to_i
    @checksum = parts[3].as(String)
  end

  def valid?
    checksum == generate_checksum
  end

  def generate_checksum
    order[0, 5].map(&.char).join
  end

  def counts
    name.chars.group_by(&.itself).map do |char, list|
      Pair.new(list.size, char)
    end
  end

  def order
    counts.sort
  end

  def decoded_name
    raw_name.chars.map { |chr| rotate chr }.join
  end

  def rotate(char)
    return " " if char == '-'
    rotated = char + sector % 26
    rotated > 'z' ? rotated - ('z' - 'a' + 1) : rotated
  end

  struct Pair
    include Comparable(self)

    property count : Int32
    property char : Char

    def initialize(@count, @char)
    end

    def <=>(other)
      if count == other.count
        char <=> other.char
      else
        other.count <=> count
      end
    end
  end
end
