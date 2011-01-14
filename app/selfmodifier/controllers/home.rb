require "sinatra"

require "selfmodifier/models/repository"

# A list of all repositories in the database
get "/" do
	repositories = Repository.all

	# Decouple the view from the model, 
	# by converting the repositories to hashes
	repo_hashes = repositories.map do |rep|
		{
			:description => rep.safe_description,
			# Tiny performance boost, putting this in database?
			:url => rep.url,
			:update_time => rep.updated,
			:name => rep.project

		}
	end

	# TODO replace with partials in the template
	table = haml :repository_table, :locals => {:projects => repo_hashes}
	haml :home, :locals => {:repositories => table}
end
