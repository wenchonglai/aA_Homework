require "set"
require "byebug"

class GraphNode
  attr_reader :val, :neighbors

  def initialize(val)
    @val = val
    @neighbors = Set.new
  end

  def has_neighbor?(node)
    @neighbors.include?(node)
  end

  def add_neighbor(node)
    @neighbors << node unless self.has_neighbor?(node)
  end

  def add_neighbors(*nodes)
    nodes.each {|node| self.add_neighbor(node)}
  end

  def remove_neighbor(node)
    @neighbors.delete(node) if self.has_neighbor?(node)
  end
  
  def remove_neighbors(*nodes)
    nodes.each {|node| self.remove_neighbor(node)}
  end

  def dfs_each(visited = Set.new, &prc)
    return nil if visited.include?(self)

    prc ||= Proc.new{|node|}
    visited << self

    return self if prc.call(self)

    @neighbors.each do |neighbor|
      val = neighbor.dfs_each(visited, &prc)

      return val unless val.nil?
    end

    nil
  end

  def dfs(target_value, visited = Set.new)
    return self.dfs_each(visited){|node| node.val == target_value}
  end

  def bfs_each(visited = Set.new, &prc)
    prc ||= Proc.new{|node|}
    queue = [self]

    until queue.empty?
      node = queue.shift

      next if visited.include?(node)

      visited << node

      return node if prc.call(node)

      queue.push(*node.neighbors)
    end
  end

  def bfs(target_value, visited = Set.new)
    return self.bfs_each(visited){|node| node.val == target_value}
  end

  def ==(node)
    @val == node.val
  end

  def eql?(node)
    @val.eql? node.val
  end

  def inspect
    "<GraphNode:#{object_id} val={#{@val.inspect} => #{@neighbors.map(&:val)}}>"
  end
end

if __FILE__ == $PROGRAM_NAME
  a = GraphNode.new('aA')
  b = GraphNode.new('bB')
  b1 = GraphNode.new('bB')
  c = GraphNode.new('cC')
  d = GraphNode.new(:dD)
  e = GraphNode.new(['eE'])
  f = GraphNode.new({'f' => :fF})
  a.add_neighbors(b, b1, c, e)
  c.add_neighbors(b, d)
  e.add_neighbors(a)
  f.add_neighbors(e)
  #puts a.inspect

  #f.dfs_each{|node| p node.val; nil }
  p f.bfs('bB')
end