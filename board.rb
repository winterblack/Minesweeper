require_relative "tile"
require 'byebug'

class Board
  attr_reader :size

  def initialize(size = 9, bombs = 10)
    @size = size
    @bombs = bombs
    @grid = Array.new(@size) {|row| Array.new(@size)}
    populate
  end

  def [](*pos)
    row, col = pos
    @grid[row][col]
  end

  def won
    non_bombs = @grid.flatten.reject(&:bomb?)
    non_bombs.all?(&:revealed)
  end

  def lost
    bombs = @grid.flatten.select(&:bomb?)
    bombs.any?(&:revealed)
  end

  def render
    puts "   " + (0..(@grid.size - 1)).to_a.join("  ")
    @grid.each_with_index do |row, i|
      print_row = []
      row.each do |tile|
        print_row << tile.render
      end
      puts "#{i} " + print_row.join('')
    end
  end

  def populate
    @size.times do |x|
      @size.times do |y|
        pos = [x, y]
        @grid[x][y] = Tile.new(self, pos)
      end
    end
    set_bombs
  end

  def set_bombs
    tiles = @grid.flatten
    shuffled_tiles = tiles.shuffle
    @bombs.times do |i|
      shuffled_tiles[i].bomb
    end
    tiles.each { |tile| tile.adjacent_bombs}
  end

  def inspect
    "Board"
  end

end
