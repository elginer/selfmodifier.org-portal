require "active_record"

module SelfModifier

	# Users
	class User < ActiveRecord::Base
		
		# Users are unique
		validates_presence_of :name
		validates_uniqueness_of :name
		# All users have passwords
		validates_presence_of :password

	end

end
