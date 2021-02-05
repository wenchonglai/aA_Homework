class Stack
  def initialize(arr)
    @data = []
    arr.each{|el| self.push(el)}
  end

  def push(el)
    @data << el
  end

  def pop
    @data.pop
  end

  def peek
    @data[-1]
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
  a = Stack.new([1,2,3])
  b = Stack.new([1,2,3])
  p a == b

  p a.inspect
  a.push('a')
  a.push('b')
  p a.inspect
  p a.pop
  p a.pop
  p a.pop
  p a.pop
  p a.pop
  p a.pop
  p a.inspect
end