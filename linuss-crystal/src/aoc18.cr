class AoC18
  T = '^'
  S = '.'

  def safe(first)
    map = rows(first, 40)
    map.sum { |row| row.sum { |tile| tile == S ? 1 : 0 } }
  end

  def safebig(first)
    map = rows(first, 400_000)
    map.sum { |row| row.sum { |tile| tile == S ? 1 : 0 } }
  end

  def rows(first, rows)
    line = first.chars
    [line] + (rows - 1).times.map { line = generate_line(line) }.to_a
  end

  def generate_line(line)
    ([S].concat(line) << S).each_cons(3).map do |(a, b, c)|
      if (a == T && b == T && c == S) ||
         (a == S && b == T && c == T) ||
         (a == T && b == S && c == S) ||
         (a == S && b == S && c == T)
        T
      else
        S
      end
    end.to_a
  end
end
