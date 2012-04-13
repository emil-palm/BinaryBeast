require 'pp'
module BinaryBeast
	class Team < BinaryBeast::Base

		def initialize(hash=nil, tournament = nil)
			super hash
			self.tournament = tournament if tournament
			self.group = hash["group"] if hash["group"]
		end

		class << self
			def load(tourney_team_id)
				BinaryBeast::Base.build("Tourney.TourneyLoad.Team", :tourney_team_id => tourney_team_id) do |response|
					if response["result"] == 200
						return BinaryBeast::Team.new(response["team_info"],nil)
					end
				end
			end
		end

		def group=(value)
			if self.tournament.groups[value]
				self.send("group=",self.tournament.groups[value])
			else
				self.tournament.groups[value] = BinaryBeast::Group.new(value)
			end
		end

		def load
			BinaryBeast::Base.build("Tourney.TourneyLoad.Team", :tourney_team_id => self.tourney_team_id) do |response|
				response["team_info"].each_pair do |att, value|
        			self[att] = value
      			end
      			return
			end
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
				team = BinaryBeast::Team.load response['o_tourney_team_id']
			end

			return team
		end
	end
end