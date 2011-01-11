require "sinatra"

# Form to add new repository
get "/repository/add" do
	haml :repository_add
end
