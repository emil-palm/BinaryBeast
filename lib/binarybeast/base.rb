module BinaryBeast
	class Base < Hashie::Mash
		include HTTParty
		include Hashie::Extensions::MergeInitializer
		base_uri "https://binarybeast.com/api"
		format :json


		def bb_inspect(extra={})
			extras = ""
			extra.each_pair { |k,v| extras << " #{k}: #{v}"}
			"#<#{self.class.to_s}#{extras}>"
		end
		
		alias_method :to_s, :bb_inspect
		alias_method :inspect, :bb_inspect

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