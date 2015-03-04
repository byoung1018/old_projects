require 'io/console'
=begin
listen for keystrokes
keep track of cursor
update cursor location according to keystroke
rerender board system "clear"
=end


require "colorize"
require_relative "piece"

require "byebug"


class NoPieceError < ArgumentError
end

class InvalidMoveError < ArgumentError
end

class InCheckError < ArgumentError
end

class Board
  attr_accessor :grid, :cursor_location


  def initialize(populate = true)
    @grid = Array.new(8){Array.new(8)}
    populate_pieces if populate
    @cursor_location = [0, 0]
  end

  def [](position)
    x, y = position

    grid[x][y]
  end

  def []=(position, piece)
    x, y = position
    @grid[x][y] = piece
  end

  def populate_pieces
    8.times do |x|
      3.times do |y|
        self[[x, y]] = Piece.new(:w, self, [x, y]) if (x + y).even?
      end
    end

    8.times do |x|
      5.upto(7) do |y|
        self[[x, y]] = Piece.new(:b, self, [x, y]) if (x + y).even?
      end
    end
  end




  def render

    system "clear"
    puts "  a b c d e f g h\n"


    @grid.transpose.each_with_index do |row, r|
      print "#{r} "
      row.each_with_index do |piece, c|
        if (r + c).even?
          background = {:background => :blue}
        else
          background = {:background => :black}
        end

        background = {:background => :yellow} if [c, r] == cursor_location

        if piece
          print "#{piece.to_s} ".colorize(background)
        else
          print "  ".colorize(background)
        end
      end
      puts ""
    end
    puts "  0 1 2 3 4 5 6 7\n"
  end

  def perform_slide(start_location, end_location)

    piece = self[start_location]
    raise NoPieceError.new if piece.nil?
    raise InvalidMoveError.new if !piece.slide_moves.include?(end_location)

    self[end_location] = self[start_location]
    self[end_location].position = end_location
    self[start_location] = nil

    true
  end



  def perform_move(move_sequence)
    raise InvalidMoveError unless valid_move_seqence?(move_sequence)
    perform_move!(move_sequence)
    self[move_sequence[-1]].maybe_promote
  end


  def valid_move_seqence?(move_sequence)
    error_board = dup

    begin
      dup.perform_move!(move_sequence)
    rescue ArgumentError
      false
    else
      true
    end
  end

  def perform_move!(move_sequence)
     if move_sequence.size == 2
       begin
         perform_slide(*move_sequence)
       rescue InvalidMoveError
         perform_jump(*move_sequence)
       end
     else
       0.upto(move_sequence.length-2) do |i|
         perform_jump(move_sequence[i], move_sequence[i + 1])
       end
     end
  end

  def perform_jump(start_location, end_location)
    piece = self[start_location]
    raise NoPieceError.new if piece.nil?
    raise InvalidMoveError.new if !piece.jump_moves.include?(end_location)

    self[end_location] = piece
    self[end_location].position = end_location
    self[start_location] = nil

    take_piece(start_location, end_location)
  end

  def dup
    board = Board.new(false)
    all_pieces.each do |piece|
      board[piece.position] = Piece.new(piece.color, board, piece.position)
    end

    board
  end

  def all_pieces
    @grid.flatten.compact
  end

  def position_on_board?(position)
    position.all?{|location| location.between?(0, 7)}
  end


  def take_piece(start_location, end_location)
    middle_tile = [(start_location[0] + end_location[0])/2,
    (start_location[1] + end_location[1])/2]
    taken_piece = self[middle_tile]
    self[middle_tile] = nil

    self[middle_tile]
  end

  def test_move
    perform_slide([0,2], [1, 3])
  end

  def empty?(position)
    self[position].nil?
  end

end

#
# b = Board.new(false)
#
# b[[6, 2]] = Piece.new(:w, b, [6, 2])
# b[[4, 4]] = Piece.new(:w, b, [4, 4])
# b[[3, 5]] = Piece.new(:b, b, [3, 5])
# b.display
# p b.perform_move([[3,5], [5,3], [7, 1]])
# b.display


def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end


def show_single_key
  c = read_char
puts c
end

loop do

  #keystroke = read_char
  show_single_key
  # p keystroke + " blah!"
  # break if keystroke == 'q'
  # puts keystroke
end


puts "done"
