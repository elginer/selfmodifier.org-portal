require "sinatra"

require "selfmodifier/models/repository"
require "httpclient"

include SelfModifier

# Form to add new repository
get "/repository/add" do
	haml :repository_add
end

# The repository is invalid
def invalid_repository
	status 403
	haml :repository_invalid
end

# Try to save the repository
def unsafe_save_repository username, repository
	repo = Repository.new :user => username, :project => repository
	if repo.save
		haml :repository_added
	else
		status 409
		haml :repository_not_saved
	end
end

# A new repository is to be added
post "/repository/add" do
	username = params[:username]
	repository = params[:repository]
	# Test these are legal github user and repository names
	# Prevent arbitrary links :)
	if /^\w(-|\w)*$/.match(username) and /^(-|\w)+$/.match(repository)

		# So the username and repository are okay.  Try to see if the project actually exists.
		client = HTTPClient.new
		exists = client.head("https://github.com/#{username}/#{repository}").code == 200
		if exists
			unsafe_save_repository username, repository
		else
			invalid_repository
		end
	else
		invalid_repository
	end
end
