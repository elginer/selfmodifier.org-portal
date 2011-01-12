require "selfmodifier/cron"
require "selfmodifier/database"

require "selfmodifier/models/repository"

require "selfmodifier/lib/github_interface"

require "set"

module SelfModifier

	# Communicate with github, on a regular basis, to find information about the repositories
	class GitHubAsker < Cron
	
		def initialize
			@github = GitHubInterface.new	
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
				@current -= working
				working.each do |rep|
			        	@github.write_details rep
				end
			end
		end

		protected

		# The number of minutes between runs
		def interval
			30
		end

		# Reset the jobs list
		def reset
			@delay = interval - 1 
			@current = Set.new fetch_repositories
		end

		# Fetch all repositories
		def fetch_repositories
			Repository.all
		end
	end

end
