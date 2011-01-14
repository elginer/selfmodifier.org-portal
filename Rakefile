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

desc "Perform initial setup, use with domain parameter."
task :setup => ["app/selfmodifier/config.rb"]

desc "If the config file does not exist, create it.  Use with domain parameter."
file "app/selfmodifier/config.rb" do
	Rake::Task[:new_config].invoke
end

desc "Create a new config file with random secret session key.  Pass domain as parameter."
# Recreate the config file
# Oh fuck but this horrible looking
task :new_config do
	possibles = (32..126).map {|code| code.chr}
	secret = possibles.map {possibles[rand(possibles.length)]} .join
	secret.gsub! "'", "\\'"
	session_source = <<END
require "rack"

Sinatra::Base.use Rack::Session::Cookie, :key => 'rack.session',
	:domain => 'selfmodifier.org',
	:path => '/user/',
	:expire_after => 3600,
	:secret => '#{secret}'
END
	store = File.open "app/selfmodifier/config.rb", "w"
	store.write session_source
	store.close
end
