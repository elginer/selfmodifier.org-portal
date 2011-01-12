require "selfmodifier/model/repository"

module SelfModifier

	# Interface for github.com API
	class GitHubInterface

		# Write the details into the repository and save it
		def write_details rep
			info = details rep
			repository.owner = info[:owner]
			repository.updated = info[:updated]
			repository.description = info[:description]
			# Check the repositoy has not been deleted...
			if Repository.find_by_user_and_project rep.user, rep.project
				unless repo.save
					STDERR.puts "GitHubInterface could not save repository."
				end
			end
		end

		# Fetch the 

	end

end
