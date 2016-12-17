require "crypto/md5"

class AoC17
  property code : String
  property queue : Deque(Move)

  alias Move = Tuple(Complex, String)

  def initialize(@code)
    @queue = Deque(Move).new
  end

  def search
    paths do |path|
      return path
    end
  end

  def longest
    longest = nil
    paths do |path|
      longest = path
    end
    longest.size if longest
  end

  def paths
    pos = initial = {Complex.new(0, 0), ""}
    @queue << initial
    while @queue.any?
      pos, path = @queue.shift
      if pos == Complex.new(3, 3)
        yield path
      else
        @queue.concat moves(pos, path)
      end
    end
  end

  def moves(pos, path)
    doors(pos, path).select { |(c, _)| 0 <= c.real < 4 && 0 <= c.imag < 4 }
  end

  def doors(pos, path)
    u, d, l, r = Crypto::MD5.hex_digest(code + path).chars[0..3]
    moves = [] of Move
    chars = "bcdef".chars
    moves << {pos + Complex.new(-1, 0), path + "U"} if chars.includes?(u)
    moves << {pos + Complex.new(1, 0), path + "D"} if chars.includes?(d)
    moves << {pos + Complex.new(0, -1), path + "L"} if chars.includes?(l)
    moves << {pos + Complex.new(0, 1), path + "R"} if chars.includes?(r)
    moves
  end
end
