require "sinatra/activerecord/rake"

# Load our application
require "./app/selfmodifier"
require "selfmodifier/database"
require "selfmodifier/models/moderator"

# Register a new moderator
task :new_moderator do
	desc "Create a new moderator, using parameters user and password"
	user = ENV["user"]
	password = ENV["password"]
	SelfModifier::Moderator.register user, password
end
