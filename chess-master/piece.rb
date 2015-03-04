# require_relative 'board'
require 'byebug'

class Piece

  attr_accessor :color, :position, :board, :diagonal_deltas, :orthogonal_deltas

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
    @diagonal_deltas = [-1,1].repeated_permutation(2).to_a
    @orthogonal_deltas = [[1, 0],
                          [-1, 0],
                          [0, 1],
                          [0, -1]]
  end

  def displace(position, delta)
    [position[0] + delta[0], position[1] + delta[1]]
  end

  def can_take?(position)
    return false unless @board.location_occupied?(position)
    @board[position].color != color
  end

  def move_into_check?(next_move)
    board_dup = board.dup
    board_dup.move!(self.position, next_move)
    board_dup.in_check?(color)
  end

  def safe_moves(potentials)
    potentials.reject { |move| move_into_check?(move) }
  end
end
