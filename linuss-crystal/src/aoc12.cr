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

  def self.compute23a(fname)
    machine = new(File.read fname)
    machine.registers["a"] = 7
    machine.process!
    machine.registers["a"].to_s
  end

  def self.compute23b(fname)
    machine = new(File.read fname)
    machine.registers["a"] = 12
    machine.process!
    machine.registers["a"].to_s
  end

  alias Value = Int32 | String

  property registers : Hash(String, Int32)
  property pc : Int32
  property instructions : Array(String)
  property arguments : Array(Array(Value))
  property program : Array(Array(String))

  def initialize(instructions)
    @pc = 0
    @program = instructions.lines.map(&.split)
    @instructions, @arguments = init

    @registers = {
      "a" => 0,
      "b" => 0,
      "c" => 0,
      "d" => 0,
    }
    optimize
  end

  def init
    {
      program.map(&.first),
      program.map(&.[1..-1]).map do |vals|
        vals.map do |v|
          if v =~ /\d/
            v.to_i
          else
            v
          end
        end
      end,
    }
  end

  def resolve(v)
    if v.is_a?(Int32)
      v
    else
      registers[v]
    end
  end

  def optimize
    @instructions, @arguments = init
    (instructions.size - 2).times do |i|
      i1, a1 = instructions[i], arguments[i]
      i2, a2 = instructions[i + 1], arguments[i + 1]
      i3, a3 = instructions[i + 2], arguments[i + 2]
      if i3 == "jnz" && a3[1]? == -2
        if i2 == "dec" && a2[0] == a3[0] && i1 == "inc"
          instructions[i] = "add"
          instructions[i + 1] = "nop"
          instructions[i + 2] = "nop"
          arguments[i] = [a2[0], a1[0]]
        end
      end
    end
  end

  def process!
    while @pc < instructions.size
      instruction = instructions[@pc]
      arg1 = arguments[@pc][0]?
      arg2 = arguments[@pc][1]?
      case instruction
      when "nop"
      when "add"
        registers[arg2] += resolve(arg1) if arg2.is_a?(String)
      when "cpy"
        registers[arg2] = resolve(arg1) if arg2.is_a?(String)
      when "inc"
        registers[arg1] += 1 if !arg2 && arg1.is_a?(String)
      when "dec"
        registers[arg1] -= 1 if !arg2 && arg1.is_a?(String)
      when "jnz"
        @pc += resolve(arg2) - 1 if resolve(arg1) != 0 && arg2
      when "tgl"
        unless arg2
          idx = resolve(arg1) + pc
          if 0 <= idx < instructions.size
            program[idx][0] = toggle(instructions[idx])
            optimize
          end
        end
      else
        puts "instruction skipped: #{instruction}"
        # do nothing!
      end
      @pc = @pc + 1
    end
  end

  def toggle(old)
    case old
    when "inc"
      "dec"
    when "tgl", "dec"
      "inc"
    when "jnz"
      "cpy"
    when "cpy"
      "jnz"
    else
      raise "unknown instruction #{old}"
    end
  end
end
