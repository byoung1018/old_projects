require "byebug"

class Piece
  attr_accessor :position, :is_king, :color

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position

  end



  def maybe_promote
    is_king = true if color == :w && position[1] == 7
    is_king = true if color == :b && position[1] == 0
  end

  def to_s
    if color == :w
      if is_king
        "W" #'\26C1'.encode('utf-8')
      else
        "w" #'\26C0'.encode('utf-8')
      end
    else
      if is_king
        "B" #'\26C3'.encode('utf-8')
      else
        "b" #'\26C2'.encode('utf-8')
      end
    end
  end

  DIRECTIONS = {:w => [[1, 1], [-1, 1]], :b => [[1, -1], [-1, -1]]}
  def move_directions
    is_king ? DIRECTIONS[:w] + DIRECTIONS[:b] : DIRECTIONS[color]


  end

  def slide_moves
    slide_moves = []
    check_move_in_directions do |move|
      slide_moves << move if valid_move(move)
    end

    slide_moves
  end

  def valid_move(move)
    @board.position_on_board?(move) && @board.empty?(move)
  end

  def displace(position = self.position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end

  def check_move_in_directions(position = self.position, &prc)
    move_directions.each do |direction|
      prc.call(displace(position, direction), direction)
    end
  end

  def jump_moves(position = self.position)
    jump_moves = []
    check_move_in_directions(position) do |move, direction|
      next unless @board.position_on_board?(move) && !@board.empty?(move)
      jump_move = displace(move, direction)
      if valid_move(jump_move)
        jump_moves << jump_move
        # jump_moves += jump_moves(jump_move)
      end
    end

    jump_moves
  end


end
