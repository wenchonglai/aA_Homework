class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    self.reset_game
  end

  def play
    until @game_over
      self.take_turn
    end

    self.game_over_message
    self.reset_game
  end

  def take_turn
    self.show_sequence
    self.require_sequence
    return if @game_over
    self.round_success_message
    @sequence_length += 1
  end

  def show_sequence
    self.add_random_color
    p @seq
    sleep 0.5 * @sequence_length
    system 'clear'
  end

  def require_sequence
    hash = {'b' => 'blue', 'r' =>'red', 'g' => 'green', 'y' => 'yellow'}
    p "enter color sequence:"

    while true
      input = gets.chomp.downcase.split('')

      break if input.length == @sequence_length &&
        input.all? {|ch| ['b', 'r', 'g', 'y'].include?(ch)}

      p "invalid input! enter again:"
    end

    if input.map{|el| hash[el]} != @seq
      @game_over = true
    end
  end

  def add_random_color
    seq << %w(red blue yellow green).sample
  end

  def round_success_message
    p "success! next round:"
  end

  def game_over_message
    p "game over!"
  end

  def reset_game
    @sequence_length = 1
    @game_over = false
    @seq = []
  end
end

if __FILE__ == $PROGRAM_NAME
  s = Simon.new
  s.play
end