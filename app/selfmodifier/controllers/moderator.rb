require "sinatra"

get "/user/login" do
	haml :login
end

post "/user/login" do
	username = params[:username]
	password = params[:password]
	if session_key = Moderator.authenticate(username, password)
		session[:session_id] = session_key
		redirect "/user/moderation"
	else
		haml :login_failed
	end
end
