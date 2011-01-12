require "sinatra"

# Our SelfModifier module
module SelfModifier

	# The top level directory
	DIR = File.dirname __FILE__

	# Set the PATH
	$:.unshift DIR

	# Set the views directory
	set :views, DIR + "/selfmodifier/views"

	# Load a bunch of files from a directory
	def SelfModifier.require_all dir
		absolute_dir = SelfModifier::DIR + "/" + dir
		plugins = Dir.entries(absolute_dir).reject {|plug| not /^.+\.rb$/.match plug}
		plugins.each do |f|
			require dir + "/" + f
		end
	end

	# Load the database settings
	require "selfmodifier/database"

	# Load all controllers and models
	["selfmodifier/controllers",
	"selfmodifier/models"].each do |subdir|
		SelfModifier.require_all subdir
	end

end
