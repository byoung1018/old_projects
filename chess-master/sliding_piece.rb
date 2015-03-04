require_relative 'piece'
require 'byebug'

class SlidingPiece < Piece

  def moves(deltas)
    potentials = []
    deltas.each do |delta|
      next_move = displace(self.position, delta)
      while @board.move_on_board?(next_move)
        if @board.location_occupied?(next_move)
          potentials << next_move if can_take?(next_move)
          break
        end
        potentials << next_move
        next_move = displace(next_move, delta)
      end
    end

    potentials
  end

end
