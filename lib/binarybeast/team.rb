require 'pp'
module BinaryBeast
	class Team < BinaryBeast::Base
		def inspect(extras={})
			return super({:name => self.display_name }) if self.key? :display_name
			return super({:id => self.tourney_team_id }) if self.key? :tourney_team_id
		end
		alias_method :org_initialize, :initialize

		def initialize(hash={}, tournament = nil, &block)

			org_initialize(hash, nil, &block)
			self.tournament = tournament if tournament
			self.group = hash["group"]
			# self.tournament.groups[self.group.letter] << self if self.group and tournament
		end

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
				self.tournament.groups[value] = BinaryBeast::Group.new(value)
			end
		end

		def group
			self['group']
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