
class Piece
	attr_accessor :location, :player_id, :king

	def initialize(location)
		@location = location #array of [y, x]
		@location[0] > 4  ? @player_id = "White" : @player_id = "Black"
		@king = false
	end

	def move(board)
	end

	def dup_piece
	end

	def render
		"C|"
	end

end #end Piece class

