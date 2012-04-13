module BinaryBeast
	class Group < BinaryBeast::Base
		def initialize(letter)
			@teams = []
			@letter = letter
		end

		def letter=(letter)
			@letter = letter
		end

		def letter
			@letter
		end

		def teams
			@teams
		end

		def <<(team)
			@teams << team
		end
	end
end