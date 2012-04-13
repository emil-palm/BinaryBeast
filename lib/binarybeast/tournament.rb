module BinaryBeast
	class Tournament < BinaryBeast::Base

		def inspect(extras={})
			return super({:title => self.title }) if self.key? :title
			return super({:id => self.tourney_id }) if self.key? :tourney_id
		end
		alias_method :org_initialize, :initialize
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
        			self[att] = value
      			end
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

		def initialize(hash = {}, default = nil, &block)
			org_initialize hash, default, &block
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