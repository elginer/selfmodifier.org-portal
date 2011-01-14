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

# Create a new secret
task :new_secret do
	desc "Create a new secret session key"
	possibles = (32..126).map {|code| code.chr}
	secret = possibles.map {possibles[rand(possibles.length)]} .join
	secret.gsub! "'", "\\'"
	session_source = <<END
require "rack"

Sinatra::Base.use Rack::Session::Cookie, :key => 'rack.session',
	:domain => 'selfmodifier.org',
	:path => '/repository/edit',
	:expire_after => 3600,
	:secret => '#{secret}'
END
	store = File.open "app/selfmodifier/session.rb", "w"
	store.write session_source
	store.close
end
