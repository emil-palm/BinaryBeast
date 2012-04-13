require 'httparty'
require 'hashie'
module BinaryBeast
	class Base < Hashie::Dash
		include HTTParty
		base_uri "https://binarybeast.com/api"
		format :json

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