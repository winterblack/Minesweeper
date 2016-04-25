require_relative 'board'

class Game

  def initialize(size = 9)
    bombs = (size*size)/8
    @board = Board.new(size, bombs)
    play
  end

  def play
    until @board.won || @board.lost
      system("clear")
      @board.render
      pos, action = get_move
      move(pos, action)
    end
    puts "YOU WIN!" if @board.won
    puts "BOOM!" if @board.lost
  end

  def move(pos, action = nil)
    tile = @board[*pos]
    tile.explore unless action == "f"
    tile.flag if action == "f"
  end

  def get_move
    row, col, action = gets.chomp.split(" ")
    [[row.to_i, col.to_i], action]
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Enter a custom board size, or hit enter for a standard game."
  size = gets.chomp.to_i
  size = 9 if size == 0
  Game.new(size)
end
