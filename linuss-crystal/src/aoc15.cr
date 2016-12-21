class AoC15
  record(Disc, period : Int64, pos : Int64) do
    def solve(product)
      (pos * b(product) * (product / period)) % product
    end

    def b(product)
      m_mi = (product / period) % period
      (m_mi ** (period - 2)) % period
    end
  end

  property discs : Array(Disc)

  def self.process(file)
    new(File.read file).calculate
  end

  def self.process11(file)
    aoc = new(File.read file)
    aoc.discs << Disc.new(11i64, aoc.discs.size.to_i64 + 1)
    aoc.calculate
  end

  def initialize(input)
    @discs = parse(input)
  end

  def parse(input)
    input.lines.map do |l|
      if l.match(/Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)./)
        # Might as well account for the time offset directly. Ball will pass instantaneously.
        Disc.new($2.to_i64, ($3.to_i64 + $1.to_i64) % $2.to_i64)
      else
        raise "Unknown input: #{l}"
      end
    end
  end

  def calculate
    period_product - (discs.map(&.solve(period_product)).sum % period_product)
  end

  def period_product
    discs.map(&.period).product
  end
end
