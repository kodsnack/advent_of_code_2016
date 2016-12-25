class AoC25
  def self.find_clock
    finder = new
    (0..Int32::MAX).find do |i|
      vals = finder.get_20(i)
      vals == [0, 1] * 10
    end
  end

  def initialize
  end

  def get_20(val)
    vals = [] of Int32
    process(val) do |i|
      return vals if vals.size == 20
      vals << i
    end
  end

  def process(val)
    a = val
    # d = a #     cpy a d
    # c = 4 # cpy 4 c
    # b = 633 # cpy 633 b
    # d += 1 # inc d
    # b -= 1 # dec b
    b = 0 # d = a+633   # jnz b -2
    # c-= 1    # dec c
    c = 0 #  d = c * 633    # jnz c -5
    while true
      a = d = val + 2532 # cpy d a
      while a != 0       # jnz 0 0
        # b = a # cpy a b
        # a = 0   # cpy 0 a
        # # while b != 0   # jnz b 2
        # #   # jnz 1 6
        # #   c = 2 # reordered! # cpy 2 c
        # #   b -= 1 # dec b
        # #   c -= 1 # dec c
        # #   next if c == 0 # jnz c -4
        # #   a += 1 # inc a
        # a = a + b / 2 # end # jnz 1 -7
        # c = b.odd? ? 1 : 2 # "
        # #b = 2 # cpy 2 b
        # # while c != 0  # jnz c 2
        # #   # jnz 1 4
        # #   b -= 1 # dec b
        # #   c -= 1 # dec c
        # # end # jnz 1 -4
        #   c = 0
        # # jnz 0 0
        # yield b.odd? ? 1 : 0   # out b
        a, b = a.divmod(2)
        yield b
      end # jnz a -19
    end   # jnz 1 -21
  end
end
