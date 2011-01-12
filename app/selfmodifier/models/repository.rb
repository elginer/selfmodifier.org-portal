require "active_record"

module SelfModifier

	class Repository < ActiveRecord::Base
		validates_uniqueness_of :user
		validates_uniqueness_of :project, :scope => :user

		def full_name
			"Unknown (#{self.user})"
		end

		def description
			"Description not yet available."
		end
	end

end
