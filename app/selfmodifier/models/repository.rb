require "active_record"

module SelfModifier

	class Repository < ActiveRecord::Base
		validates_uniqueness_of :username
		validates_uniqueness_of :project, :scope => :username
	end

end
