require 'httparty'

module BinaryBeast
	class Tournament < BinaryBeast::Base
		property :title
		property :status
		property :type_id
		property :location
		property :game_code
		property :game
		property :teams_confirmed_count
		property :tourney_id
		property :type
		property :tourney_team_id

		def self.list
			self.build("Tourney.TourneyList.My") do |response|
				{
					:created => response['result']['creator']['list'].map { |c| BinaryBeast::Tournament.new(c) },
					:joined => response['result']['player']['list'].map { |c| BinaryBeast::Tournament.new(c) }
				}
			end
		end

		def teams(force = false)
			unless force 
				@teams if defined? @teams 
				@teams =  _load_teams
			else
				@teams = nil
				@teams = _load_teams 
			end

			return @teams
		end

		def groups
			@groups
		end

		def initialize(opts)
			super opts
			@groups = {}
		end

		def _load_teams
			BinaryBeast::Base.build("Tourney.TourneyLoad.Teams",:tourney_id => self.tourney_id) do |response|
				response['teams'].map { |t| BinaryBeast::Team.new(self,t) }
			end
		end

		# def info
		# 	BinaryBeast::Base.build("Tourney.TourneyLoad.Info", :tourney_id => self.tourney_id ) do |response|
				
		# 	end
		# end
	end
end