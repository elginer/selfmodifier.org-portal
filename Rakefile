require "sinatra/activerecord/rake"

# Load our application
require "./app/selfmodifier"
require "selfmodifier/database"
require "selfmodifier/models/moderator"

desc "Start the server in production mode."
task "start" do
	sh "./dispatch.fcgi"
end

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

desc "Create a new secret for the sessions"
file "app/selfmodifier/secret.rb" do
	puts "started."
	syms = ("!".."~").to_a
	secret = (0..50).map do
		syms[rand(syms.size)]
	end .join
	gen = File.open "app/selfmodifier/secret.rb", "w"
	gen.write <<-END
module SelfModifier

	SECRET = "#{secret}"
end
END
	gen.close
end
