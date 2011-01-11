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
		Dir.entries(absolute_dir).each do |f|
			dir + "/" + f
		end
	end

	# Load the database settings
	require "selfmodifier/database"

	# Load all controllers, models, and users
	["selfmodifier/controllers",
	"selfmodifier/models",
	"selfmodifier/users"].each do |subdir|
		SelfModifier.require_all subdir
	end

end


