require "sinatra/activerecord/rake"

# Load our application
require "./app/selfmodifier"
require "selfmodifier/database"
require "selfmodifier/models/moderator"

desc "Create a new moderator, using parameters user and password"
# Register a new moderator
task "db:create_moderator" do
	user = ENV["USER"]
	password = ENV["PASSWORD"]
	if user and password
		SelfModifier::Moderator.register user, password
	else
		fail "Usage: rake db:create_moderator USER=name PASSWORD=secret"
	end
end
