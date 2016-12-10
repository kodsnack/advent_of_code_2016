class AoC10
  def self.compute(fname)
    machine = new(File.read fname)
    machine.process!
    machine.output(0).value * machine.output(1).value * machine.output(2).value
  end

  property bots
  property outputs
  property action_queue

  def initialize(instructions)
    @bots = {} of Int32 => Bot
    @outputs = {} of Int32 => Output
    @action_queue = [] of Bot
    instructions.each_line { |l| parse l }
  end

  def process!
    until action_queue.empty?
      action_queue.shift.act
    end
  end

  def parse(line)
    case line
    when /value (\d+) goes to bot (\d+)/
      bot($2.to_i).get($1.to_i)
    when /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
      bot($1.to_i).instruct low: bot_or_output($2, $3.to_i),
        high: bot_or_output($4, $5.to_i)
    else
      raise "Unknown input: #{line}"
    end
  end

  def enqueue(bot)
    action_queue << bot
  end

  def bot_or_output(type, i)
    if type == "bot"
      bot(i)
    else
      output(i)
    end
  end

  def bot(i)
    unless bots[i]?
      bots[i] = Bot.new i, self
    end
    bots[i].as Bot
  end

  def output(i)
    unless outputs[i]?
      outputs[i] = Output.new i
    end
    outputs[i].as Output
  end

  class Bot
    property id : Int32
    property machine : AoC10
    property values
    property low_receiver : Bot | Output
    property high_receiver : Bot | Output

    def initialize(@id, @machine)
      @values = [] of Int32
      @high_receiver = Output.new -1
      @low_receiver = Output.new -1
    end

    def can_act?
      values.size == 2
    end

    def low
      values.min || -1
    end

    def high
      values.max || -1
    end

    def get(value)
      values << value
      machine.enqueue self if can_act?
    end

    def instruct(low, high)
      @low_receiver = low
      @high_receiver = high
    end

    def act
      if values.sort == [17, 61]
        puts to_s + " compared the values"
      end
      #   puts "bot #{id}: low (#{low}) -> #{low_receiver.to_s}; high (#{high}) -> #{high_receiver.to_s}"
      low_receiver.get(low)
      high_receiver.get(high)
    end

    def to_s
      "bot: #{id}"
    end
  end

  class Output
    property id : Int32
    property value

    def initialize(@id)
      @value = -1
    end

    def get(value)
      @value = value
    end

    def to_s
      "output: #{id}"
    end
  end
end
