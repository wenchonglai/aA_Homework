class DoubleLinkedListNode
  attr_reader :prev, :next, :val

  def initialize(val)
    @val = val
    @prev = nil
    @next = nil
  end

  def append(node)
    node.prev.next = nil if node.prev
    self.next.prev = nil if self.next

    node.prev = self
    self.next = node
  end

  def detach
    self.prev.next = nil if self.prev
    self.next.prev = nil if self.next
  end
  
  def inspect
    "<@val: #{val.inspect}, @prev: #{@prev && @prev.val.inspect}, @next: #{@next && @next.val.inspect}>"
  end

  protected
  attr_writer :prev, :next, :val
end

class DoubleLinkedList
  attr_reader :length

  def initialize
    @head = DoubleLinkedListNode.new(nil)
    @tail = DoubleLinkedListNode.new(nil)
    @head.append(@tail)
    @length = 0
  end

  def <<(val)
    node = DoubleLinkedListNode.new(val)
    @tail.prev.append(node)
    node.append(@tail)
    @length += 1
    self
  end

  def unshift(val)
    node = DoubleLinkedListNode.new(val)
    node.append(@head.next)
    @head.append(node)
    @length += 1
    self
  end

  def pop
    return nil if empty?
    
    tail_prev = @tail.prev
    tail_prev.prev.append(@tail)
    tail_prev.detach
    @length -= 1
    tail_prev.val
  end

  def shift
    return nil if empty?

    head_next = @head.next
    @head.append(head_next.next)
    head_next.detach
    @length -= 1
    head_next.val
  end

  def length
    @length
  end

  def empty?
    @length.zero?
  end

  def last
    @tail.prev
  end

  def print
    node = @head.next
    arr = []

    until node == @tail
      arr << node.val 
      node = node.next
    end
      
    p arr
  end

  def inspect
    str = "<@length: #{@length}, @head: #{@head.inspect}, "
    
    node = @head.next

    until node == @tail
      str += "#{node.inspect}, " 
      node = node.next
    end

    str + "@tail: #{@tail.inspect}>"
  end
end

class LRUCache
  def initialize(size)
    @size = size
    @list = DoubleLinkedList.new
    @hash = {}
  end

  def count
    @list.length
  end

  def add(item)
    key = item.hash

    if @hash.has_key?(key)
      node = @hash[key]
      last = @list.last
      tail = last.next
      node.prev.append(node.next)
      last.append(node)
      node.append(tail)
    else
      @list << item
      @hash[key] = @list.last
      @hash.delete(@list.shift.hash) if @list.length > @size
    end
  end

  def show
    @list.print
  end

  private
end

if __FILE__ == $PROGRAM_NAME
  johnny_cache = LRUCache.new(4)

  johnny_cache.add("I walk the line")
  johnny_cache.add(5)

  p johnny_cache.count # => returns 2
  johnny_cache.show

  johnny_cache.add([1,2,3])
  johnny_cache.add(5)
  johnny_cache.add(-5)
  johnny_cache.add({a: 1, b: 2, c: 3})
  johnny_cache.add([1,2,3,4])
  johnny_cache.add("I walk the line")
  johnny_cache.add(:ring_of_fire)
  johnny_cache.add("I walk the line")
  johnny_cache.add({a: 1, b: 2, c: 3})

  p johnny_cache.count
  johnny_cache.show # => prints [[1, 2, 3, 4], :ring_of_fire, "I walk the line", {:a=>1, :b=>2, :c=>3}]
end
