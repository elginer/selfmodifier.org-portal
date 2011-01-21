require "rack/builder"
require "./app/selfmodifier"

module SelfModifier

	# YOU must add the host for production.
	HOST = "localhost" 
end

run SelfModifier::App.new

