require_relative 'piece'

class SteppingPiece < Piece

  def moves(deltas)
    potentials = []
    deltas.each do |delta|
      move = displace(position, delta)
      next unless @board.move_on_board?(move)
      next if @board.location_occupied?(move) && !can_take?(move)
      potentials << move
    end

    potentials
  end

end
