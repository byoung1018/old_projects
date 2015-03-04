require_relative 'stepping_piece'

class King < SteppingPiece

  def moves(deltas = orthogonal_deltas + diagonal_deltas)
    super
  end

  def to_s
    (self.color == :b) ? :♚ : :♔
  end

end
