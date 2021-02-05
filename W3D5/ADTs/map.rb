class Map
  def initialize(arr_2d = [])
    @data = []
    arr_2d.map{|pair| self.set(*pair)}
  end

  def set(key, val)
    i = index_of(key)
    if i.nil?
      @data << [key, val]
    else
      @data[i][1] = val
    end
  end

  def get(key)
    i = index_of(key)
    @data[i][1] unless i.nil?
  end

  def delete(key)
    i = index_of(key)
    @data.delete_at(i) unless i.nil?
  end

  def show
    @data.map{|pair| [*pair]}
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

  private
  def index_of(key)
    @data.each_with_index{|pair, i| return i if pair[0].eql? key}
    nil
  end

  protected
  attr_reader :data
end

if __FILE__ == $PROGRAM_NAME
  a = Map.new([[1,'a'],[2,'b'],['3','c'],[4,'d'],[5,'e']])
  b = Map.new([[1,'a'],[2,'b'],['3','c'],[4,'d'],[5,'e']])
  p a == b

  a.show
  a.delete('3')
  p a.get('3')
  p a.show
  p a.set(3, 'C')
  p a.show
  p a.get('3')
  p a.get(3)

  a.set([1,2], '3,4')
  a.set([1,2], '5,6')
  p a.show
end