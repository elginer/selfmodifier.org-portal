require "selfmodifier/models/repository"

module SelfModifier

	class App
		# A list of all repositories in the database
		get "/" do
			repositories = Repository.all

			# TODO replace with partials in the template
			table = haml :repository_table, :locals => {:projects => repositories}
			haml :home, :locals => {:repositories => table}
		end

	end
end
