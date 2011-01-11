require "sinatra"
require "selfmodifier/models/repository"

include SelfModifier

# Form to add new repository
get "/repository/add" do
	haml :repository_add
end

# A new repository is to be added
post "/repository/add" do
	Repository.new :user => params[:username], :project => params[:repository]
end
