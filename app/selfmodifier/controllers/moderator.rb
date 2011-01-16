require "sinatra"

# Unauthorized access
def unauthorized
	status 403
	haml :login_failed
end

get "/user/login" do
	haml :login
end

post "/user/login" do
	username = params[:username]
	password = params[:password]
	if mod = Moderator.authenticate(username, password)
		session[:user_id] = mod.id
		redirect "/user/moderation"
	else
		unauthorized
	end
end

get "/user/moderation" do
	if user = session[:user_id]
		me = Moderator.find_by_id(user).username
		everyone = Moderator.all.map {|mod| mod.username}
		repos = Repository.all.map {|repo| {:user => repo.user, :project => repo.project}}
		haml :moderation, :locals => {:me => me, :everyone => everyone, :projects => repos}
	else
		unauthorized
	end
end
