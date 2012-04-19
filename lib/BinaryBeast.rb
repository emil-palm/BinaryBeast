require 'binarybeast/base'

module BinaryBeast
	require 'httparty'
	require 'ostruct'



	def self.api_key=(api_key)
		@@api_key = api_key
	end

	def self.api_key
		@@api_key
	end
end