require_relative 'piece'

class Pawn < Piece

  def initialize(color, board, position)
    super
    @start_position = position
  end

  def deltas
    if color == :w
      [[0, 1], [-1, 1], [1, 1]]
    else
      [[0, -1], [-1, -1], [1, -1]]
    end
  end

  def moves
    potentials = []
    deltas.each do |delta|
      move = displace(position, delta)
      next unless @board.move_on_board?(move)
      if delta[0] == 0
        potentials += forward_potentials(move, delta)
      else
        potentials << move if @board.location_occupied?(move) && can_take?(move)
      end
    end
    potentials
  end

  def forward_potentials(move, delta)
    fwd_potentials = []
    return fwd_potentials if @board.location_occupied?(move)
    fwd_potentials << move
    if position = @start_position
      double_move = displace(move, delta)
      fwd_potentials << double_move unless @board.location_occupied?(double_move)
    end
    fwd_potentials
  end

  def to_s
    (self.color == :b) ? :♟ : :♙
  end

end
