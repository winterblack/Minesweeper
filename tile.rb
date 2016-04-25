class Tile
  attr_reader :revealed, :flagged

  def initialize(board, pos)
    @board = board
    @pos = pos
    @revealed = false
    @bomb = false
    @flagged = false
  end

  def explore
    unless revealed
      reveal
      adjacent_tiles.each do |tile|
        tile.explore if adjacent_bombs == 0
      end
    end
  end

  def bomb
    @bomb = true
  end

  def bomb?
    @bomb
  end

  def reveal
    @revealed = true
  end

  def flag
    flagged ? @flagged = false : @flagged = true
  end

  def render
    if flagged
      "[F]"
    elsif revealed
      "[#{adjacent_bombs}]"
    else
      "[ ]"
    end
  end

  def inspect
    @flagged ? "flagged" : " #{@adjacent_bombs} "
    # @bomb ? "bomb" : " #{@adjacent_bombs} "
  end

  def adjacent_tiles
    x, y = @pos
    tiles = []
    ((x - 1)..(x + 1)).each do |row|
      ((y - 1)..(y + 1)).each do |col|
        if row.between?(0, (@board.size - 1)) && col.between?(0, (@board.size - 1))
          tiles << [row, col]
        end
      end
    end
    tiles.map{|pos| @board[*pos]}
  end

  def adjacent_bombs
    adjacent_tiles.select(&:bomb?).count
  end

end
