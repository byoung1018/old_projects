class Player
  attr_accessor :color

  def initialize(color)
    @color = color
  end

end


class HumanPlayer < Player

  def play_turn
    puts "#{(color == :w) ? "White" : "Black"}, please enter start and end coordinates."
    columns = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }
    locations = gets.chomp.split(" ")
    locations.map do |pos|
      [columns[pos[0]], pos[1].to_i]
    end
  end

end


class ComputerPlayer < Player

  attr_accessor :board

  def initialize(color, board = nil)
    super(color)
    @board = board
  end

  def play_turn
    gets
    play_random
  end


  private

    def all_moves
      all_moves = Hash.new { |h, k| h[k] = []}
      board.all_pieces.each do |piece|
        all_moves[piece] += piece.moves if (piece.color == color)
      end
      all_moves
    end

    def get_valid_moves(piece)

    end

    def play_random
      my_piece = board.all_pieces.select {|piece| piece.color == color}.sample
      until my_piece.moves.length > 0
        my_piece = board.all_pieces.select {|piece| piece.color == color}.sample
      end
      get_move = my_piece.moves.sample
      [my_piece.position, get_move]
    end

end
