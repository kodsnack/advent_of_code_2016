class AoC11
  def self.compute(fname)
    machine = new(File.read(fname))
    x = machine.search
    # machine.print
    x
  end

  def self.computeb(fname)
    machine = new(File.read(fname))
    floor = machine.state.floors.first
    floor.add AoC11::Microchip.new("elerium")
    floor.add AoC11::Microchip.new("dilithium")
    floor.add AoC11::Generator.new("elerium")
    floor.add AoC11::Generator.new("dilithium")

    x = machine.search
    # machine.print
    x
  end

  FLOORS = 4
  property state

  def initialize(instructions)
    @state = State.new
    state.parse instructions
  end

  def print
    current = state
    res = [current]
    while current = current.previous
      res << current
    end
    puts res.reverse.map(&.to_s).join("\n--\n")
  end

  def search
    queue = Array(Tuple(State, Int32)).new
    seen = Set(Hash(String, Int32)).new
    current = @state
    move = 0
    queue << {current, move}
    current_move = move
    until current.done? || queue.empty?
      current, move = queue.shift
      if current_move < move
        # p({move, queue.size})
        current_move = move
      end
      current.moves.each do |state|
        next if seen.includes?(state.hash)
        queue << {state, move + 1}
        seen << state.hash
      end
    end
    @state = current
    move
  end

  record(Generator, type : String) do
    def to_s
      "G#{type}"
    end
  end

  record(Microchip, type : String) do
    def to_s
      "M#{type}"
    end
  end

  alias Contents = Generator | Microchip

  class State
    property floors : Array(Floor)
    property elevator : Int8
    property estimation
    property previous : self | Nil
    property to_s : String?

    def initialize
      @floors = Array(Floor).new(4) { Floor.new }
      @elevator = 0i8
      @previous = nil
      @to_s = nil
    end

    def initialize(s : State, @elevator)
      @floors = Array(Floor).new
      s.floors.each { |f| @floors << f }
      @previous = s
      @to_s = nil
    end

    def hash
      pairs = {"e" => elevator.to_i32}
      floors.each_with_index do |f, i|
        f.chips.each.with_index do |c, ci|
          pairs["#{i} #{ci}"] = floors.index do |f2|
            f2.contents.find { |g| g.type == c.type && c != g }
          end || -1
        end
      end
      pairs
    end

    def parse(instructions)
      instructions.each_line.with_index do |l, i|
        floors[i].parse(l)
      end
    end

    def to_s
      @to_s ||= floors.each.with_index.map do |(f, i)|
        (i == elevator ? "E " : "  ") + f.to_s
      end.to_a.reverse.join("\n")
    end

    def move(moves, current, offset)
      moves.map do |m|
        s = self.class.new(self, current + offset)
        s.floors[current] = s.floors[current].new_without(*m)
        s.floors[current + offset] = s.floors[current + offset].new_with(*m)
        s
      end
    end

    def moves
      current_floor = floors[elevator]
      moves = current_floor.contents.product(current_floor.contents.to_a)
      next_states = Array(self).new
      if elevator != 0
        next_states.concat move(moves, elevator, -1)
      end
      if elevator != 3
        next_states.concat move(moves, elevator, 1)
      end
      next_states.select &.valid?
    end

    def done?
      floors[0..2].all? &.contents.empty?
    end

    def valid?
      floors.all? &.valid?
    end
  end

  struct Floor
    property contents

    def_clone

    def new_without(*vals)
      new = clone
      new.contents -= vals.to_a
      new
    end

    def new_with(*vals)
      new = clone
      new.contents |= vals.to_a
      new
    end

    def initialize
      @contents = Array(Contents).new
    end

    def add(content)
      @contents << content
    end

    def chips
      contents.select &.is_a?(Microchip)
    end

    def generators
      contents.select &.is_a?(Generator)
    end

    def to_s
      contents.map(&.to_s).sort.join(" ")
    end

    def valid?
      return true if contents.none? &.is_a?(Generator)
      (chips.map(&.type) - generators.map(&.type)).none?
    end

    def parse(l)
      return nil if l =~ /nothing relevant/
      l = l.gsub(/.* contains /, "").chomp(".\n")
      contents = l.split(/, and | and |, /)
      contents.map do |kind|
        if kind =~ /a (.*)-compatible microchip/
          add Microchip.new($1.not_nil!)
        elsif kind =~ /a (.*) generator/
          add Generator.new($1.not_nil!)
        else
          raise "Unknown type #{kind}"
        end
      end
    end
  end
end
