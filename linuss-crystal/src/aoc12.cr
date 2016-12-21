class AoC12
  def self.compute(fname)
    machine = new(File.read fname)
    machine.process!
    machine.registers["a"].to_s
  end

  def self.computeb(fname)
    machine = new(File.read fname)
    machine.registers["c"] = 1
    machine.process!
    machine.registers["a"].to_s
  end

  property registers : Hash(String, Int32)
  property pc : Int32
  property instructions : Array(String)

  def initialize(instructions)
    @pc = 0
    @instructions = instructions.lines
    @registers = {
      "a" => 0,
      "b" => 0,
      "c" => 0,
      "d" => 0,
    }
  end

  def process!
    while @pc < instructions.size
      case instruction = instructions[@pc]
      when /cpy (\d+) ([a-d])/
        registers[$2] = $1.to_i
      when /cpy ([a-d]) ([a-d])/
        registers[$2] = registers[$1]
      when /inc ([a-d])/
        registers[$1] += 1
      when /dec ([a-d])/
        registers[$1] -= 1
      when /jnz ([a-d]) (-?\d+)/
        if registers[$1] != 0
          @pc += $2.to_i - 1
        end
      when /jnz (-?\d+) (-?\d+)/
        if $1.to_i != 0
          @pc += $2.to_i - 1
        end
      else
        raise "WTF: #{instruction}"
      end
      @pc = @pc + 1
    end
  end
end
