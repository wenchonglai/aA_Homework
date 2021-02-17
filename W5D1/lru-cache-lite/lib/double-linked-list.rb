class DoubleLinkedListNode
  attr_reader :prev, :next, :val

  def initialize(val = nil)
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
    return nil if empty?
    @tail.prev
  end

  def first
    return nil if empty?
    @head.next
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