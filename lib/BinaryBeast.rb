autoload 'HTTParty', 'httparty'
autoload 'OpenStruct', 'ostruct'
module BinaryBeast

	autoload :Base,     	     'binarybeast/base'
	autoload :Group,        	 'binarybeast/group'
	autoload :Team,          	 'binarybeast/team'
	autoload :Tournament,		 'binarybeast/tournament'

	def self.api_key=(api_key)
		@@api_key = api_key
	end

	def self.api_key
		@@api_key
	end
end