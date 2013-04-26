
class Piece
	attr_accessor :location, :player_id, :king

	def initialize(location)
		@location = location #array of [y, x]
		@location[0] > 4  ? @player_id = "White" : @player_id = "Black"
		@king = false
		@slide_directions = slide_directions
		@jump_directions = jump_directions
	end

	def slide_directions
		#check spot for empty
		if @player_id == "White"
			[[-1,-1],[-1,+1]]
		elsif @player_id == "Black"
			[[1,-1],[1,+1]]
		end
	end

	def jump_directions
		#check first spot for enemy
		#check second spot for empty
		if @player_id == "White"
			[[[-1,-1],[-2,-2]],[[-1,+1],[-2,+2]]]
		elsif @player_id == "Black"
			[[[1,-1],[2,-2]],[[-1,+1],[2,+2]]]
		end
	end

	def dup_piece
		new_piece = Piece.new(self.location)
		new_piece.player_id = self.player_id
		new_piece
	end

	def render
		"C|"
	end

	def perform_moves(move_seq, board)
		#move_seq is player input (an array of positions)
		#board is board object
		valid = valid_move_seq?(move_seq, board)

		if valid
			perform_moves!(move_seq, board)
		else
			puts "Not valid move" #raise/return the error exception
		end
	end


	def valid_move_seq?(move_seq, board)
		#move_seq is player input (an array of positions)
		#board is a board object (real)
		#calls perform_moves! on dupped board
		#returns true if perform_moves! succeeds
		#returns false if perform_moves! raises an error
		#must catch the error!
		board_clone = board.dup # must write custome dup method for board!!!!

		begin
			perform_moves!(move_seq, board_clone)
		rescue InvalidMoveError => e
			puts "Error was: #{e.message}"
			return false
		end

		true
	end


	def perform_moves!(move_seq, board)
		#move_seq is player input (an array of positions)
		#board is a board object (will be duped or real, depending on use)
		#iterate through sequence and call #perform_slide or #perform_jump to validate each move
		## those methods should change the board state so that the next move in the sequence
		## is operating on the changed board
		## if any move cannot occur (invalid) - an error should be raised
		move_seq.each_index do |i|
			next if i == move_seq.size
			#determine if move is #jump or #slide, let's assume slide for now!
			move = [move_seq[i],move_seq[i+1]] # [start,end]
			perform_slide(move, board) # or jump, depending on case!
		end
	end

	def perform_slide(move, board)
		#takes a slide move [start,end]
		#checks if it's valid with #slide_moves(start, board)
		#if not valid, raise error!
		#if valid, execute move!
		available_moves = slide_moves(start, board)
		if available_moves.include?(move)
			#actually make move
		else
			raise InvalidMoveError.new "Cannot make this slide move!"
		end
	end

	def slide_moves(start, board)
		#takes in the current board
		#returns an array of available slide moves
		#assumes no kings for now!
		possible_moves = @slide_directions.map do |dir|
			[start[0] + dir[0], start[1] + dir[1]]
		end

		possible_moves.select do |move|
			true if board.grid[move[0]],[move[1]].nil?
		end
	end

	def jump_moves(board)
		#takes in the current board
		#returns an array of available jump moves
		#assumes no kings for now!
	end

	


end #end Piece class

