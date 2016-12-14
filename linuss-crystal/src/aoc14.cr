require "crypto/md5"

class AoC14
  alias IndexKey = Tuple(Int64, String)
  alias CharIndexKey = Tuple(Char, Int64, String)

  property iterator : KeyIterator

  def initialize(input, iterator)
    @iterator = KeyIterator.new input, iterator
  end

  def at(idx)
    iterator.first(63).to_a
    iterator.next.first
  end

  class KeyIterator
    include Iterator(IndexKey)

    property threes : Array(CharIndexKey)
    property found : Array(IndexKey)
    property md5s : MD5Iterator

    def initialize(input, iterator)
      @md5s = iterator.new(input)
      @threes = Array(CharIndexKey).new
      @found = Array(IndexKey).new
    end

    def next
      while true
        idx, key = @md5s.next
        if (five_char = five?(key))
          while threes.first[1] < idx - 1000
            threes.shift
          end
          found.concat threes.select { |(char, _, _)| five_char == char }.map { |_, i, s| {i, s} }
          found.uniq!
          found.sort_by! &.first
        end
        if (char = three?(key))
          threes << {char, idx, key}
        end
        return found.shift if found.any? && found.first.first < idx - 1000
      end
    end

    def three?(key)
      x = y = '\0'
      key.chars.find do |c|
        return c if x == c && y == c
        x, y = y, c
        false
      end
      nil
    end

    def five?(key)
      w = x = y = z = '\0'
      key.chars.find do |c|
        return c if [w, x, y, z].all? &.==(c)
        w, x, y, z = x, y, z, c
        false
      end
      nil
    end
  end

  class MD5Iterator
    include Iterator(IndexKey)

    property input : String

    def initialize(@input)
      @i = 0i64
    end

    def next
      ret = {@i, hash}
      @i += 1
      ret
    end

    def hash
      Crypto::MD5.hex_digest(input + @i.to_s)
    end
  end

  class StretchedMD5Iterator < MD5Iterator
    def hash
      hsh = super
      2016.times { hsh = Crypto::MD5.hex_digest(hsh) }
      hsh
    end
  end
end
