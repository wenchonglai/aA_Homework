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
