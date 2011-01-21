module SelfModifier

	class App
		# Unauthorized access
		def unauthorized
			log "Unauthorized action refused!"
			status 401
			haml :login
		end

		# Only run a block if authorized
		# pass the username of the authorized user to the block
		def with_auth 
			if mod_id = session[:user]
				mod = Moderator.find_by_id(mod_id).username
				if mod
					log "Action by #{mod} authorized."
					yield mod
				else
					raise "Mod does not exist: #{mod_id}"
				end
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
				user = params[:user]
				project = params[:project]
				repo = Repository.find_by_user_and_project user, project
				if repo
					repo.delete
					log "User #{me} deleted #{user}/#{project}."
				else
					log_error "User #{me} could not delete repository #{user}/#{project}."
				end
				moderation me
			end
		end

	end
end
