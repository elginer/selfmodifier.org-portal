require "active_record"

module SelfModifier

	# Moderators
	class Moderator < ActiveRecord::Base
		validates_uniqueness_of "username"
	end

end
