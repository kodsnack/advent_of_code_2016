class AoC19
  property count : Int32

  def initialize(@count)
  end

  def steal
    remaining = Deque(Int32).new
    (1..count).each do |i|
      remaining << i
    end
    while remaining.size > 1
      val = remaining.shift
      remaining.shift
      remaining << val
    end
    remaining.shift
  end

  def steal_opposite
    list = List.new
    (1..count).each do |i|
      list << i
    end
    delete_node = list.first
    (count/2).times do
      delete_node = delete_node.nxt
    end
    while list.size > 1
      val = list.shift
      list.delete delete_node
      delete_node = list.size.odd? ? delete_node.nxt.nxt : delete_node.nxt
      list << val
    end
    list.shift
  end

  class List
    class Placeholder
      macro method_missing(call)
        raise "nope"
      end
    end

    class Node
      property val : Int32
      property nxt : self | Placeholder
      property prev : self | Placeholder

      def initialize(@val)
        @nxt = Placeholder.new
        @prev = Placeholder.new
      end
    end

    property first : Node | Placeholder
    property size : Int32

    def initialize
      @first = Placeholder.new
      @size = 0
    end

    def <<(val)
      @size += 1
      node = Node.new(val)
      if !first.is_a?(Placeholder)
        node.nxt = first
        node.prev = first.prev
        first.prev.nxt = node
        first.prev = node
      else
        @first = node
        node.nxt = node
        node.prev = node
      end
    end

    def shift
      delete(first).val
    end

    def delete(node)
      @size -= 1
      node.nxt.prev, node.prev.nxt = node.prev, node.nxt
      if node == first
        @first = node.nxt
      end
      if size == 0
        @first = Placeholder.new
      end
      node
    end
  end
end
