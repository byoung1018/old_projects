require_relative 'sliding_piece'

class Bishop < SlidingPiece

  def moves(deltas = diagonal_deltas)
    super
  end

  def to_s
    (self.color == :b) ? :♝ : :♗
  end

end
