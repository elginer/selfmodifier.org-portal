require "sinatra"

# Our SelfModifier module
module SelfModifier

	# The top level directory, for file inclusion
	DIR = File.dirname __FILE__

	# Set the sinatra root
	set :root, DIR + "/selfmodifier/" 

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
		# Load the database settings
		require "selfmodifier/database"

		# Load the cron system
		require "selfmodifier/cron"

		# Load all controllers and models
		["selfmodifier/controllers",
		"selfmodifier/models",
		"selfmodifier/cron"].each do |subdir|
			SelfModifier.require_all subdir
		end

		enable :sessions

		Cron.fork
	end

end
