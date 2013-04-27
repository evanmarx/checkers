

class Board
	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) {nil} }
		fill_board
	end

	def fill_board # REV: lots of repetition. Could run this with a loop.
		#player 1
		@grid[0][1] = Piece.new([0, 1])
    	@grid[0][3] = Piece.new([0, 3])
    	@grid[0][5] = Piece.new([0, 5])
    	@grid[0][7] = Piece.new([0, 7])
    	
    	@grid[1][0] = Piece.new([1, 0])
    	@grid[1][2] = Piece.new([1, 2])
    	@grid[1][4] = Piece.new([1, 4])
    	@grid[1][6] = Piece.new([1, 6])

		@grid[2][1] = Piece.new([2, 1])
    	@grid[2][3] = Piece.new([2, 3])
    	@grid[2][5] = Piece.new([2, 5])
    	@grid[2][7] = Piece.new([2, 7])

    	#player 2
    	@grid[7][0] = Piece.new([7, 0])
    	@grid[7][2] = Piece.new([7, 2])
    	@grid[7][4] = Piece.new([7, 4])
    	@grid[7][6] = Piece.new([7, 6])
    	
    	@grid[6][1] = Piece.new([6, 1])
    	@grid[6][3] = Piece.new([6, 3])
    	@grid[6][5] = Piece.new([6, 5])
    	@grid[6][7] = Piece.new([6, 7])

		@grid[5][0] = Piece.new([5, 0])
    	@grid[5][2] = Piece.new([5, 2])
    	@grid[5][4] = Piece.new([5, 4])
    	@grid[5][6] = Piece.new([5, 6])
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
    # REV: Don't you already build a grid when new_board is initialized?
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
			@grid[piece.location[0]][piece.location[1]].slide_moves([piece.location[0],piece.location[1]], self).size != 0 || @grid[piece.location[0]][piece.location[1]].jump_moves([piece.location[0],piece.location[1]], self).size != 0
		# REV: 200ish lines is too long not to get a comment.
    end
	end

end #end Board class


