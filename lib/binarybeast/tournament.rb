require 'pp'
module BinaryBeast
	class Tournament < BinaryBeast::Base
		class Match
			attr_accessor :team1, :team2, :round, :group, :bracket
			class << self
				def from_hash(hash)
					BinaryBeast::Tournament::Match.new.from_hash hash
				end

				def from_completed_hash(hash)
					BinaryBeast::Tournament::Match.new.from_completed_hash hash
				end
			end
			def from_hash(hash)
				self.team1 = BinaryBeast::Team.new(hash["team"])
				self.team2 = BinaryBeast::Team.new(hash['opponent'])
				self.round = hash["round"]
				self.bracket = hash["bracket"]
				self.group = hash["group"]
				self
			end

			def from_completed_hash(hash)
				self.team1 = BinaryBeast::Team.new({:tourney_team_id => hash["tourney_team_id"]})
				self.team2 = BinaryBeast::Team.new({:tourney_team_id => hash["o_tourney_team_id"]})
				self.round = hash["round"]
				self.bracket = hash["bracket"]
				self.group = hash["group"]
				self
			end
		end

		def self.list
			self.build("Tourney.TourneyList.My") do |response|
				{
					:created => response['result']['creator']['list'].map { |c| BinaryBeast::Tournament.new(c) },
					:joined => response['result']['player']['list'].map { |c| BinaryBeast::Tournament.new(c) }
				}
			end
		end

		def load
			BinaryBeast::Base.build("Tourney.TourneyLoad.info", :tourney_id => self.tourney_id ) do |response|
				response["tourney_info"].each_pair do |att, value|
					self.send("#{att}=", value)
      			end
      			return self
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
			teams unless @groups
			@groups
		end

		def initialize(hash = nil)
			super hash
			@groups = {}
		end

		def upcoming_matches
			BinaryBeast::Base.build("Tourney.TourneyLoad.OpenMatches", :tourney_id => self.tourney_id) do |resp|
				return resp["matches"].map { |m| BinaryBeast::Tournament::Match.from_hash(m) }
			end
		end

		def completed_matches(force=false)
			BinaryBeast::Base.build("Tourney.TourneyMatch.Stream", :tourney_id => self.tourney_id, :all => force) do |resp|
				return resp["matches"].map { |m| BinaryBeast::Tournament::Match.from_completed_hash(m) }	
			end
		end

		def _load_teams
			BinaryBeast::Base.build("Tourney.TourneyLoad.Teams",:tourney_id => self.tourney_id) do |response|
				response['teams'].map { |t| BinaryBeast::Team.new(t,self) }
			end
		end

		def submit_score(winner, loser, winner_score, loser_score)
			BinaryBeast::Base.build("Tourney.TourneyTeam.ReportWin", 
				:tourney_id => self.tourney_id, 
				:tourney_team_id => winner,
				:o_tourney_team_id => loser,
				:score => winner_score,
				:o_score => loser_score
			) do |response|
				[response['tourney_match_id'],response['tourney_match_game_id']]
			end
		end

		def submit_score_rounds(match_id, winners,winner_scores,loser_scores, maps)
			BinaryBeast::Base.build("Tourney.TourneyMatchGame.ReportBatch", 
				:tourney_match_id => match_id,
				:tourney_id => self.tourney_id, 
				:winners => winners,
				:scores => winner_scores,
				:o_scores => loser_scores,
				:maps => maps
			) do |response|
				response
			end
		end
	end
end