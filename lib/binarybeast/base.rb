require 'group'
require 'team'
require 'tournament'

module BinaryBeast

	class Base < OpenStruct
		include HTTParty
		base_uri "https://binarybeast.com/api"
		format :json


		def inspect
			"#<#{self.class.to_s}>"
		end

		def self.build(method,args={})
			args.merge! ({ 
							:api_key => BinaryBeast::api_key, 
							:api_service => method, 
							:api_use_underscores => true
						})
			response = self.get("/", :query => args)
			if response.code == 200 and ![404, 403].include? response["Result"]
				yield response if block_given?
			end
		end
	end
end