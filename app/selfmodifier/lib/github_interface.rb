require "selfmodifier/models/repository"
require "selfmodifier/lib/log"

require "httpclient"

require "json"

require "time"

module SelfModifier

	# Tiny interface for what we need from github.com API
	class GitHubInterface


		# Create from a user name and repository name
		# Makes a request across the network, to github
		def initialize user, project
			@user = user
			@project = project
		end

		# Write the details into the related database repository
		# NOTE this isn't covered by the test suite
		def update! 

			# Request an update from github
			web_request

			# Check the repositoy has not been deleted... this is in a cron job after all!
			if repo = Repository.find_by_user_and_project(@user, @project)
				repo.updated = @push_time
				repo.description = @description
				if repo.save				
					log "Repository #@user/#@project has been updated."
				else
					log_error "Repository #@user/#@project could not be saved."
				end
			end
		end

		private

		# It's bad to break enapsulation
		# Unit testing loads to this sort of thing a lot...
		attr_reader :push_time, :description


		# Request an update from github
		def web_request 
			with_logging do
				url = "http://github.com/api/v2/json/repos/show/#{@user}/#{@project}"
				log "GET #{url}"
				client = HTTPClient.new
				raw = client.get(url).body.dump
				repo_hash = JSON.parse(raw)["repository"]
				@push_time = Time.parse(repo_hash["pushed_at"])
				@description = repo_hash["description"]
			end
		end

	end

end
