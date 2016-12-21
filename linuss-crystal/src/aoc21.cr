class AoC21
  property input : Array(Char)

  def initialize(input)
    @input = input.chars
  end

  def process(fname)
    execute(File.read(fname)).join
  end

  def unscramble(fname)
    execute_reverse(File.read(fname)).join
  end

  def execute(command_list)
    command_list.lines.each do |command|
      handle_command(command)
    end
    input
  end

  def execute_reverse(command_list)
    command_list.lines.reverse.each do |command|
      reverse_command(command)
    end
    input
  end

  def handle_command(command)
    case command
    when /swap position (\d+) with position (\d+)/
      a, b = $1.to_i, $2.to_i
      input[a], input[b] = input[b], input[a]
    when /swap letter ([[:alpha:]]) with letter ([[:alpha:]])/
      a = input.index($1[0]) || -1
      b = input.index($2[0]) || -1
      input[a], input[b] = input[b], input[a]
    when /rotate (left|right) (\d+) step/
      sign = $1 == "right" ? 1 : -1
      rotate(sign * $2.to_i)
    when /rotate based on position of letter ([[:alpha:]])/
      idx = input.index($1[0]) || -1
      rotate(idx + 1)
      rotate(1) if idx > 3
    when /reverse positions (\d+) through (\d+)/
      a, b = $1.to_i, $2.to_i
      input[a..b] = input[a..b].reverse
    when /move position (\d+) to position (\d+)/
      a, b = $1.to_i, $2.to_i
      val = input[a]
      input.delete_at(a)
      @input = case b
               when 0
                 [val].concat input
               when input.size
                 input << val
               else
                 input[0..(b - 1)] + [val] + input[b..-1]
               end
    else
      raise "Unknown command"
    end
  end

  # Note: Size 5 is irreversible as index 2 and 4 both map to index 0.
  MAP = {
    1 => 0,
    3 => 1,
    5 => 2,
    7 => 3,
    2 => 4,
    4 => 5,
    6 => 6,
    0 => 7,
  }

  def reverse_command(command)
    case command
    when /rotate (left|right) (\d+) step/
      sign = $1 == "left" ? 1 : -1
      rotate(sign * $2.to_i)
    when /rotate based on position of letter ([[:alpha:]])/
      idx2 = input.index($1[0]) || raise "nope"
      rotate(MAP[idx2] - idx2)
    when /move position (\d+) to position (\d+)/
      handle_command("move position #{$2} to position #{$1}")
    else
      handle_command(command)
    end
  end

  def rotate(steps)
    steps = input.size - steps % input.size
    @input = input[steps..-1] + input[0..(steps - 1)]
  end
end
