load 'piece.rb'
load 'error.rb'

class Board
	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) {nil} }
		fill_board
	end

	def fill_board
    	@grid[0][0] = Piece.new([0, 0])
  	end

	def display
		@grid.each_with_index do |row, y|
			puts ""
			row.each_with_index do |square, x|
				if @grid[y][x]
					print @grid[y][x].render
				else
					print "_|"
				end
			end
		end
	end


end #end Board class


