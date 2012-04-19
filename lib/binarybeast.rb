require 'httparty'
require 'ostruct'
require 'binarybeast/base'

module BinaryBeast



	def self.api_key=(api_key)
		@@api_key = api_key
	end

	def self.api_key
		@@api_key
	end
end