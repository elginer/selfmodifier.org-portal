require "sinatra"

# Our SelfModifier module
module SelfModifier

	# The top level directory
	DIR = File.dirname __FILE__

	# Set the PATH
	$:.unshift DIR

	# Load a bunch of files from a directory
	def SelfModifier.require_all dir
		absolute_dir = SelfModifier::DIR + "/" + dir
		plugins = Dir.entries(absolute_dir).reject {|plug| not /^.+\.rb$/.match plug}
		plugins.each do |f|
			require dir + "/" + f
		end
	end

	# Run selfmodifier
	def SelfModifier.run
		# Set the views directory
		set :views, DIR + "/selfmodifier/views"

		# Load the database settings
		require "selfmodifier/database"

		# Load the cron system
		require "selfmodifier/cron"

		# Load the config file
		require "selfmodifier/config"

		# Load all controllers and models
		["selfmodifier/controllers",
		"selfmodifier/models",
		"selfmodifier/cron"].each do |subdir|
			SelfModifier.require_all subdir
		end

		Cron.fork
	end

end
