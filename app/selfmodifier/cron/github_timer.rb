require "selfmodifier/cron"
require "selfmodifier/database"

require "selfmodifier/models/repository"

require "selfmodifier/lib/github_interface"
require "selfmodifier/lib/log"

require "set"

module SelfModifier

	# Communicate with github, on a regular basis, to find information about the repositories
	class GitHubTimer < Cron
	
		def initialize
			reset
		end

		# Find 20 repositories to update, and contact github about them.
		# If there are no current repositories, then an interval should pass before this method should run again.
		def run
			if @current.empty?
				if @delay > 0
					@delay -= 1
				else
					reset
				end
			else
				working = Set.new @current.take 20
				log "Working through #{working.size} repositories."
				@current -= working
				working.each do |rep|
			        	rep.update!
				end
			end
		end


		# The number of minutes between runs
		def interval
			10	
		end

		# Reset the jobs list
		def reset
			@delay = interval - 1 
			@current = Set.new fetch_repositories
		end

		# Fetch all repositories
		def fetch_repositories
			Repository.all.map do |rep|
				GitHubInterface.new rep.user, rep.project
			end
		end
	end

end
