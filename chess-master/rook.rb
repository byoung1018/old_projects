require_relative 'sliding_piece'

class Rook < SlidingPiece

  def moves(deltas = orthogonal_deltas)
    super
  end

  def to_s
    (self.color == :b) ? :♜ : :♖
  end

end
