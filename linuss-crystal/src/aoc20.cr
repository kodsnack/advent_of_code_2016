class AoC20
  alias List = Array(Tuple(Int64, Int64))
  property blacklist : List

  def self.find(file)
    new(File.read file).find
  end

  def self.count(file)
    new(File.read file).count
  end

  def initialize(blacklist)
    @blacklist = List.new
    @blacklist.concat parse(blacklist).sort_by &.first
    compact
  end

  def find
    (0..UInt32::MAX).find { |v| !blacklisted?(v) }
  end

  def compact
    l = List.new
    l << blacklist.first
    blacklist[1..-1].each do |(low, high)|
      if low <= l[-1].last + 1
        l[-1] = {l[-1].first, [l[-1].last, high].max}
      else
        l << {low, high}
      end
    end
    @blacklist = l
  end

  def count(max = UInt32::MAX)
    sum = (blacklist.first.first == 0 ? 0 : blacklist.first.first - 1).to_i64
    sum += blacklist.each_cons(2).sum { |(low, high)| high.first - low.last - 1 }
    blacklist.last.last >= max ? sum : sum + (max - blacklist.last.last)
  end

  def parse(blacklist)
    blacklist.lines.map do |l|
      l =~ /(\d+)-(\d+)/
      {$1.to_i64, $2.to_i64}
    end
  end

  def blacklisted?(v)
    blacklist.find { |(low, high)| low <= v <= high }
  end
end
