autoload 'HTTParty', 'httparty'
autoload 'OpenStruct', 'ostruct'
autoload 'BinaryBeast'

module BinaryBeast
	require 'httparty'
	require 'ostruct'

	require 'binarybeast/base'


	def self.api_key=(api_key)
		@@api_key = api_key
	end

	def self.api_key
		@@api_key
	end
end