
module BinaryBeast
	class Team < BinaryBeast::Base
  		property :wins
  		property :losses
  		property :draws
		property :points
		property :display_name
		property :game_wins
		property :game_losses
		property :game_draws
		property :game_difference
		property :tourney_team_id

		property :country
		property :country_code
		property :country_code_short
		property :status
		property :network_display_name
		

		def group=(value)
			if self.tournament.groups[value] 
				self.[]=("group",self.tournament.groups[value])
			else
				self.[]=("group", BinaryBeast::Group.new(value))
				self.tournament.groups[value] ||= self.group 
			end
		end

		def group
			self['group']
		end
		property :group
		
		def initialize(tournament, hash)
			super hash
			self.tournament = tournament
			self.group = hash["group"] if hash["group"]
			self.tournament.groups[self.group.letter] << self if self.group
		end

		def tournament=(tournament)
			@tournament = tournament
		end

		def tournament
			@tournament
		end
	end
end