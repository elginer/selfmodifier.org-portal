require "active_record"

module SelfModifier

	class Repository < ActiveRecord::Base
		validates_uniqueness_of :user
		validates_uniqueness_of :project, :scope => :user

	end

end
