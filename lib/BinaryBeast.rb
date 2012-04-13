require 'pp'
require 'binarybeast/base'
require 'binarybeast/group'
require 'binarybeast/team'
require 'binarybeast/tournament'

module BinaryBeast
	def self.api_key=(api_key)
		@@api_key = api_key
	end

	def self.api_key
		@@api_key
	end
end