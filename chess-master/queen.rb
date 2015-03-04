require_relative 'sliding_piece'

class Queen < SlidingPiece

  def moves(deltas = orthogonal_deltas + diagonal_deltas)
    super
  end

  def to_s
    (self.color == :b) ? :♛ : :♕
  end

end
