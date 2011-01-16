require "sinatra/activerecord/rake"

# Load our application
require "./app/selfmodifier"
require "selfmodifier/database"
require "selfmodifier/models/moderator"

desc "Create a new moderator, using parameters user and password"
# Register a new moderator
task :new_moderator do
	user = ENV["user"]
	password = ENV["password"]
	SelfModifier::Moderator.register user, password
end
