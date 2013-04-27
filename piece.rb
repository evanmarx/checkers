require 'debugger' # REV: should remove this before pushing to GitHub

class Piece
	attr_accessor :location, :player_id, :king, :alive

	def initialize(location)
		@location = location #array of [y, x]
		@location[0] > 4  ? @player_id = "White" : @player_id = "Black" 
    # REV: consider setting color in the fill_board method
		@king = false
		@slide_directions = slide_directions
		@jump_directions = jump_directions
		@alive = true
	end

	def slide_directions
		#check spot for empty
		if @player_id == "White" # REV: why not use color instead of player_id?
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
			[[[1,-1],[2,-2]],[[1,+1],[2,+2]]]
		end
	end

	def dup_piece
		new_piece = Piece.new(self.location)
		new_piece.player_id = self.player_id
		new_piece
	end

	def render
		player_id == "White" ? "W|" : "B|"
	end

	def perform_moves(move_seq, board)
		#move_seq is player input (an array of positions)
		#board is board object
		valid = valid_move_seq?(move_seq, board)

		if valid # REV: just move the valid_move_seq? method call here.
			perform_moves!(move_seq, board)
		else
			[]
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

		if move_seq.size == 2 && (move_seq[0][0] - move_seq[1][0]).abs == 1
			move_type = Proc.new {|m| perform_slide(m, board)}
		else
			move_type = Proc.new {|m| perform_jump(m, board)}
		end
			

		move_seq.each_index do |i|
			next if i == move_seq.size-1
			move = [move_seq[i],move_seq[i+1]] # [start,end]
			move_type.call(move, board) 
		end
	end

	def perform_slide(move, board)
		#takes a slide move [start,end]
		#checks if it's valid with #slide_moves(start, board)
		#if not valid, raise error!
		#if valid, execute move!
		available_moves = slide_moves(move[0], board)
		if available_moves.include?(move[1])
			board.grid[move[1][0]][move[1][1]] = board.grid[move[0][0]][move[0][1]] 
			board.grid[move[0][0]][move[0][1]] = nil
			self.location = [move[1][0], move[1][1]]
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
			true if board.grid[move[0]][move[1]].nil? && (move[0].between?(0,7) && move[1].between?(0,7))
		# REV: The above line is 90ish chars. Try to keep them under 80.
    end
	end

	def perform_jump(move, board)
		available_moves = jump_moves(move[0], board)
		moved = false

		available_moves.each do |pair|
			if pair[1] == move[1]
				board.grid[move[1][0]][move[1][1]] = board.grid[move[0][0]][move[0][1]] 
				board.grid[move[0][0]][move[0][1]] = nil
				self.location = [move[1][0], move[1][1]]
				# marker for turning off error switch
				moved = true
				# delete guy at pair[0] --> abstract kill sequence
				board.grid[pair[0][0]][pair[0][1]].alive = false
				board.grid[pair[0][0]][pair[0][1]].location = nil
				board.grid[pair[0][0]][pair[0][1]] = nil
			end
		end

		raise InvalidMoveError.new "Cannot make this jump move!" if moved == false
	end


	def jump_moves(start, board)
		#takes in the current board, and a start position
		#returns an array of available jump moves
		#assumes no kings for now!
		possible_moves = @jump_directions.map do |jump|
			[[start[0] + jump[0][0], start[1] + jump[0][1]],[start[0] + jump[1][0], start[1] + jump[1][1]]]
		end

		possible_moves.select do |move|
			if not board.grid[move[0][0]][move[0][1]].nil? 
				if (board.grid[move[0][0]][move[0][1]].player_id != self.player_id) && (board.grid[move[1][0]][move[1][1]].nil?) && (move[1][0].between?(0,7) && move[1][1].between?(0,7))
					# REV: Holy crap that line is long.
          true
				end
			end
		end
	end

	


end #end Piece class

