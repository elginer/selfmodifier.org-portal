require "sinatra"
require "selfmodifier/models/repository"

include SelfModifier

# Form to add new repository
get "/repository/add" do
	haml :repository_add
end

# A new repository is to be added
post "/repository/add" do
	username = params[:username]
	repository = params[:repository]
	# Test these are legal github user and repository names
	# Prevent arbitrary links :)
	if /^\w(-|\w)*$/.match(username) and /^(-|\w)+$/.match(repository)

		repo = Repository.new :user => username, :project => repository
		repo.save
		haml :repository_added
	else
		status 403
		haml :repository_invalid
	end
end
