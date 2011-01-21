require "sinatra/base"

# Our SelfModifier module
module SelfModifier

	# The top level directory, for file inclusion
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

	require "selfmodifier/secret"

	# The selfmodifier application
	# Run SelfModifier.load
	class App < Sinatra::Base

		# Set the sinatra root
		set :root, DIR + "/selfmodifier/" 

		# Set up sessions
		use Rack::Session::Cookie, :path => '/user',
			:expire_after => 3600,
			:secret => SelfModifier::SECRET

		def initialize

			Cron.fork
			super
		end

		# Create a secure URL to a resource
		# In development, don't bother
		def App.secure path
			if production? 
				"https://#{SelfModifier::HOST}#{path}"
			else
				path
			end
		end

	end



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

end
