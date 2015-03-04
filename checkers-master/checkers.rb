require_relative 'player'
require_relative 'board'

class Checkers

  class WrongColorError < ArgumentError
  end

  def self.play_human_v_human
    game = Checkers.new(b: HumanPlayer.new(:b), w: HumanPlayer.new(:w))
    game.play
  end


  def initialize(players)
    @board = Board.new
    @players = players
  end

  def toggle_color(color)
    (color == :w) ? :b : :w
  end

  def color_valid?(start_location, color)
    @board[start_location] && @board[start_location].color == color
  end


  def key_handler(key)
    case key
    when "w"
      @board.cursor_location[0] += 1 if @board.cursor_location[0] < 7
    end
    when "d"
      @board.cursor_location[0] -= 1 if @board.cursor_location[0] > 0
    end
    when "a"
      @board.cursor_location[1] += 1 if @board.cursor_location[0] < 7
    end
    when "d"
      @board.cursor_location[1] -= 1 if @board.cursor_location[0] > 0
    end

    @board.render
end

  def play

    turn_color = :w


    puts "Aaaaaaaand go..."


    loop do
      @board.display
      break if draw?(turn_color)
      make_move(turn_color)
      break if win?(turn_color)
      turn_color = toggle_color(turn_color)
    end
  end

  def draw?(color)
    @board.all_pieces.each do |piece|
      return false if !piece.slide_moves.empty? || !piece.jump_moves.empty?
    end

    true
  end

  def make_move(turn_color)
    begin
      move_sequence = @players[turn_color].get_move_sequence
      raise WrongColorError unless color_valid?(move_sequence[0][0], turn_color)
      @board.perform_move(move_sequence)
    rescue InvalidMoveError
      puts "The piece can't move there"
      retry
    rescue WrongColorError
      puts "That ain't yose!"
      retry
    end
  end

  def win?(color)
    other_color = color == :w ? :b : :w
    @board.all_pieces.each do |piece|
      return false if piece.color == other_color
    end

    @board.display
    puts "#{color} got lucky"
    true
  end

end


Checkers.play_human_v_human
