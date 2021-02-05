class Queue
  def initialize(arr)
    @data = []
    arr.each{|el| self.enqueue(el)}
  end

  def enqueue(el)
    @data.unshift(el)
  end

  def dequeue
    @data.pop
  end

  def peek
    @data[0]
  end

  def inspect
    @data.inspect
  end

  def ==(other)
    self.eql? other
  end

  def ===(other)
    @data === other.data
  end

  def eql?(other)
    @data.eql? other.data
  end
  
  protected
  attr_reader :data
end

if __FILE__ == $PROGRAM_NAME
  a = Queue.new([1,2,3])
  b = Queue.new([1,2,3])
  p a == b

  p a.inspect
  a.enqueue('a')
  a.enqueue('b')
  p a.inspect
  p a.dequeue
  p a.dequeue
  p a.dequeue
  p a.dequeue
  p a.dequeue
  p a.dequeue
  p a.inspect
  p a.data
end