# encoding: utf-8

load 'player.rb'
load 'board.rb'
load 'piece.rb'
load 'error.rb'

class Game
	attr_accessor :board

	def initialize
		@p1 = Player.new("Player 1", "Black")
		@p2 = Player.new("Player 2", "White")
		@board = Board.new
		@current_player = @p2
		@enemy_player = @p1
		game_loop
	end

	def game_loop
		until win?
			@current_player, @enemy_player = @enemy_player, @current_player
			@board.display
			new_move = @current_player.move
			until valid_move?(new_move)
				new_move = @current_player.try_again
			end
		end 
		puts ""
		puts "#{@current_player.name} wins the game!"
		puts "Better luck next time, #{@enemy_player.name}."
	end 

	def win?
		# true on either means win for current player, return true. False otherwise
		return true if @board.no_remaining_pieces?(@enemy_player.player_id)
		return true if @board.no_remaining_moves?(@enemy_player.player_id)
		false
	end

	def valid_move?(move)
		return false if @board.grid[move[0][0]][move[0][1]].nil?
		return false if move.size < 2
		return false if @board.grid[move[0][0]][move[0][1]].player_id != @current_player.player_id
		# the next condition will execute the move if it is valid.
		return false if @board.grid[move[0][0]][move[0][1]].perform_moves(move, @board) == [] 
		# move will have been made if the last condition returned as non-empty
		true
	end



end # end Game class