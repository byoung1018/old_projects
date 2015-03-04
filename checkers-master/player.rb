class Player
  attr_accessor :color

  def initialize(color)
    @color = color
  end

end


class HumanPlayer < Player

  COLUMN_LETTERS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def get_move_sequence
    puts "#{(color == :w) ? "White" : "Black"}, play foo."


    move_sequence = gets.chomp.split(", ")
    move_sequence.map do |move|
      move = move.split(" ")
      move.map do |location|        
        [COLUMN_LETTERS[location[0]], location[1].to_i]
      end
    end
  end
end
