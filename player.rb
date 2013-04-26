class Player
	attr_accessor :name, :player_id

	def initialize(name, player_id)
		@name = name
		@player_id = player_id
	end

	def move
		puts "Please enter a starting piece, and the places you would like to move it."
		puts "For multiple moves, enter each space it will land in the sequence."
		puts "E.g. Single move: '[0,0],[1,1]'"
		puts "E.g. Jump move: '[0,0],[2,2],[4,4]'"
		move = gets.chomp #need to request/[0,0],[1,1]parse this better!
	end

	def try_again
		puts "That wasn't a valid move!"
		puts "Please enter a starting piece, and the places you would like to move it."
		puts "For multiple moves, enter each space it will land in the sequence."
		move = gets.chomp #need to request/[0,0],[1,1]parse this better!
	end

end