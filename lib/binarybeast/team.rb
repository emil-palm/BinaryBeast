
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
		property :tourney_player_id
		property :invoice_id
		property :permissions
		property :country_flag
		property :notes
		property :admin_password
		property :user_id
		property :country
		property :country_code
		property :country_code_short
		property :status
		property :network_display_name
		
		class << self
			def load(tourney_team_id)
				BinaryBeast::Base.build("Tourney.TourneyLoad.Team", :tourney_team_id => tourney_team_id) do |response|
					return BinaryBeast::Team.new(nil, response["team_info"])
				end
			end
		end

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

		def load
			BinaryBeast::Base.build("Tourney.TourneyLoad.Team", :tourney_team_id => self.tourney_team_id) do |response|
				response["team_info"].each_pair do |att, value|
        			self[att] = value
      			end
      			return
			end
		end
		
		def initialize(tournament=nil, hash)
			super hash
			self.tournament = tournament if tournament
			self.group = hash["group"] if hash["group"]
			self.tournament.groups[self.group.letter] << self if self.group and tournament
		end

		def tournament=(tournament)
			@tournament = tournament
		end

		def tournament
			@tournament
		end

		def oponent
			team = nil;
			BinaryBeast::Base.build("Tourney.TourneyTeam.GetOTourneyTeamID", :return_data =>1, :tourney_team_id => self.tourney_team_id) do |response|
				team = BinaryBeast::Team.new(response['team'])			
			end

			return team
		end
	end
end