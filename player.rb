class Player
	attr_accessor :name, :player_id

	def initialize(name, player_id)
		@name = name
		@player_id = player_id
	end

	def move
		move_seq = []
		puts 
		puts
		puts "#{@name}, #{@player_id}, please enter a starting piece's x-y coordinates, separated by a comma (e.g. '0,0')"
		move = gets.chomp
		move_seq << parse_input(move)
		
		puts 
		puts "Enter the spaces you want to move your piece."
		puts "Hit 'Enter' after every move you want to make"
		puts "When you are finished moving, hit 'Enter' on a blank line." 
		while true
			move = gets.chomp
			break if move == ""
			move_seq << parse_input(move)
		end
		move_seq
	end

	def try_again
		puts "That wasn't a valid move! Please try again"
		self.move
	end

	def parse_input(move)
		move = move.split(",")
		move.map! { |coord| coord.to_i }
		[move[1],move[0]]
	end

end