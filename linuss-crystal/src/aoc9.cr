require "string_scanner"

class AoC9
  property scanner

  def self.decompressed_size(fname)
    input = File.read fname
    new(input).decompress.size
  end

  def self.decompressed_v2_size(fname)
    input = File.read fname
    new(input).decompressv2
  end

  def initialize(string)
    @scanner = StringScanner.new(string.chomp)
  end

  def decompressv2
    size = 0i64
    until scanner.eos?
      size += (scanner.scan(/[^(]*/) || "").size
      if scanner.scan /\((?<length>\d+)x(?<times>\d+)\)/
        length = scanner["length"].to_i
        input = scanner.peek(length)
        scanner.offset += length
        size += self.class.new(input).decompressv2 * scanner["times"].to_i
      end
    end
    size
  end

  def decompress
    results = [] of String
    until scanner.eos?
      results << (scanner.scan(/[^(]*/) || "")
      if scanner.scan /\((?<length>\d+)x(?<times>\d+)\)/
        length = scanner["length"].to_i
        input = scanner.peek(length)
        scanner.offset += length
        scanner["times"].to_i.times { results << input }
      end
    end
    results.join
  end
end
