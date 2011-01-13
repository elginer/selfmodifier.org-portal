require "sinatra"

require "selfmodifier/models/repository"

# A list of all repositories in the database
get "/" do
	repositories = Repository.all

	# Decouple the view from the model, 
	# by converting the repositories to hashes
	repo_hashes = repositories.map do |rep|
		{
			:description => rep.description,
			# Tiny performance boost, putting this in database?
			:url => "http://github.com/#{rep.user}/#{rep.project}",
			:update_time => rep.updated,
			:name => rep.project

		}
	end

	table = haml :repository_table, :locals => {:projects => repo_hashes}
	haml :home, :locals => {:repositories => table}
end
