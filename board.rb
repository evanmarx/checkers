

class Board
	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) {nil} }
		fill_board
	end

	def fill_board
    	@grid[0][0] = Piece.new([0, 0])
    	@grid[7][0] = Piece.new([7, 0])
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

	def dup
		new_board = Board.new
		new_board.grid = Array.new(8) { Array.new(8) {nil} }

		@grid.each_with_index do |row, y|
			row.each_index do |x|
				next if @grid[y][x].nil?
				new_board.grid[y][x] = @grid[y][x].dup_piece
			end
		end
		new_board
	end

	def no_remaining_pieces?(enemy_player_id)
		all_remaining = @grid.flatten(2).compact
		all_remaining.none? do |piece|
			piece.player_id == enemy_player_id
		end
	end

	def no_remaining_moves?(enemy_player_id)
		all_remaining = @grid.flatten(2).compact
		all_remaining.none? do |piece| 
			next if piece.player_id != enemy_player_id
			@grid[piece.location[0]][piece.location[1]].slide_moves([piece.location[0],[piece.location[1]], self).size != 0 || @grid[piece.location[0]][piece.location[1]].jump_moves([piece.location[0],[piece.location[1]], self).size != 0
		end
	end

end #end Board class


