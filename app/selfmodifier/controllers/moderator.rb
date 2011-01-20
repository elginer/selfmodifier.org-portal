require "sinatra"

# Unauthorized access
def unauthorized
	status 403
	haml :login, :locals => {:tile => "Access denied", :message => "Login failed."}
end

# Only run a block if authorized
# pass the username of the authorized user to the block
def with_auth 
	if mod_id = session[:user]
		yield Moderator.find_by_id(mod_id).username
	else
		unauthorized
	end
end

# Display the moderation page
def moderation me
	everyone = Moderator.all.map {|mod| mod.username}
	repos = Repository.all
	haml :moderation, :locals => {:me => me, :everyone => everyone, :projects => repos}
end

get "/user/login" do
	haml :login, :locals => {:title => "Login", :message => "Enter user name and password."}
end

post "/user/login" do
	username = params[:username]
	password = params[:password]
	if mod = Moderator.authenticate(username, password)
		session[:user] = mod.id
		redirect "/user/moderation"
	else
		unauthorized
	end
end

post "/user/logout" do
	session[:user] = nil
	redirect "/"
end

get "/user/moderation" do
	with_auth do |me|
		moderation me
	end 
end

post "/user/moderation" do
	with_auth do |me|
		repo = Repository.find_by_user_and_project params[:user], params[:project]
		if repo
			repo.delete
		end
		moderation me
	end
end
