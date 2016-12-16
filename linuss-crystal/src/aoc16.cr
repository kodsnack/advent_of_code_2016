class AoC16
  property input : Array(Char)

  def initialize(input)
    @input = input.chars
  end

  def generate(size)
    data = input
    while data.size < size
      data = inflate(data)
    end
    data = data[0...size]
    checksum(data).join
  end

  def inflate(a = input)
    b = a.reverse
    b = b.map { |c| c == '0' ? '1' : '0' }
    a + ['0'] + b
  end

  def checksum(data)
    while data.size.even?
      data = data.each_slice(2).flat_map do |(a, b)|
        a == b ? '1' : '0'
      end
    end
    data
  end
end
