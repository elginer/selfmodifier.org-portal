require "selfmodifier/models/user"

Then /^a github repository, (.+)\/(.+) is added$/ do |username, repository|
	with_selenium do |sel|
		sel.open "/repository/add"
		sel.type "username-field", username
		sel.type "repository-field", repository
		sel.click "Add"
	end
end

Then /^a repository for (.+)\/(.+) is in the database$/ do |username, repository|
	unless Repository.find_by_user_and_repository(username, repository)
		raise "Repository not in database: #{username}/#{repository}"
	end
end
