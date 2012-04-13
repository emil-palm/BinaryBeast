module BinaryBeast
	class Tournament < BinaryBeast::Base
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
			@groups
		end

		def initialize(hash = nil)
			super hash
			@groups = {}
		end

		def _load_teams
			BinaryBeast::Base.build("Tourney.TourneyLoad.Teams",:tourney_id => self.tourney_id) do |response|
				response['teams'].map { |t| BinaryBeast::Team.new(t,self) }
			end
		end

		# def info
		# 	BinaryBeast::Base.build("Tourney.TourneyLoad.Info", :tourney_id => self.tourney_id ) do |response|
				
		# 	end
		# end
	end
end