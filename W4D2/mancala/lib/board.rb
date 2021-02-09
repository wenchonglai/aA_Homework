class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14){Array.new(4, :stone)}
    @cups[6] = []
    @cups[13] = []
    @names = [name1, name2]
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
  end

  def valid_move?(start_pos)
    if start_pos < 0 || start_pos > 14
      raise "Invalid starting cup"
    elsif @cups[start_pos].empty?
      raise "Starting cup is empty"
    end
  end

  def make_move(start_pos, current_player_name)
    arr, @cups[start_pos] = @cups[start_pos], []

    i = start_pos
    until arr.empty?
      i = (i + 1) % 14
      @cups[i] << arr.pop if i != ( current_player_name == @names.first ? 13 : 6 )
    end
    p [start_pos, current_player_name]
    self.render
    next_turn(i)
  end

  def next_turn(ending_cup_idx)
    if ending_cup_idx == 6 || ending_cup_idx == 13
      return :prompt
    elsif @cups[ending_cup_idx].length == 1
      return :switch
    else
      return ending_cup_idx
    end
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    return [@cups[0..5], @cups[7..12]].any?{|arr| arr.all?{|slot| slot.empty?}}
  end

  def winner
    result = @cups[6].length <=> @cups[13].length
    
    result.zero? ?
      :draw :
      result.positive? ?
        @names.first :
        @names.last
  end
end
