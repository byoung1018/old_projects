require_relative 'board'
require_relative 'player'

class Chess

  class WrongColorError < ArgumentError
  end

  def self.human_v_human
    Chess.new(b: HumanPlayer.new(:b), w: HumanPlayer.new(:w))
  end

  def self.comp_v_comp
    Chess.new(b: ComputerPlayer.new(:b), w: ComputerPlayer.new(:w))
  end

  def initialize(players)
    @board = Board.new
    @players = players
    players.each do |color, player|
       player.board = @board if player.is_a?(ComputerPlayer)
    end
  end

  def toggle_color(color)
    (color == :w) ? :b : :w
  end

  def color_valid?(start_loc, color)
    @board[start_loc].color == color
  end

  def play

    puts "Welcome to Chess."

    @board.display_board
    color = :w

    until @board.checkmate?(color)
      begin
        start_loc, end_loc = @players[color].play_turn
        raise WrongColorError unless color_valid?(start_loc, color)
        @board.move(start_loc, end_loc)
      rescue NoPieceError
        puts "There's no piece at there to move"
        retry
      rescue InCheckError
        puts "That move would put you into check"
        retry
      rescue InvalidMoveError
        puts "The piece can't move there"
        retry
      rescue WrongColorError
        puts "That piece isn't yours!"
        retry
      end

      color = toggle_color(color)
    end

    puts "Checkmate. #{(color == :w) ? "Black" : "White"} wins!"
  end
end
