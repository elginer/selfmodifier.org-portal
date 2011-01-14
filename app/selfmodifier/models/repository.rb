require "active_record"

require "rack/utils"

module SelfModifier

	class Repository < ActiveRecord::Base
		validates_uniqueness_of :project, :scope => :user

		# URL of this repository
		def url
			"http://github.com/#{self.user}/#{self.project}"
		end

		# The description of the project - safely
		def safe_description
			Rack::Utils.escape_html self.description
		end

	end

end
