require "socket"

ROOT = File.dirname(__FILE__) + "/../../"

$:.unshift ROOT + "/app"

module SelfModifier
end

include SelfModifier

def fork_process file 
	fork do
		path = File.expand_path ROOT + "/" + file
		exec path 
	end
end

# Loop until we can connect to the server
def wait_connect port
	t = nil
	until t
		begin
			t = TCPSocket.new("localhost", port)
		rescue
		end
		sleep 1
	end
	t.close
end

# Run selfmodifer
def fork_selfmodifier
	fork_process "run"
	wait_connect "4567"
	fork_process "run_selenium"
	wait_connect "4444"
end

# Stop running self modifier
def kill_selfmodifier
	if $SELENIUM_PID
		Process.kill $SELENIUM_PID
		Process.wait $SELENIUM_PID
		$SELENIUM_PID = nil
	end
	if $SERVER_PID
		Process.kill $SERVER_PID
		Process.wait $SERVER_PID
		$SERVER_PID = nil
	end
end

# Ensure the database connection is removed
def unload_database
	if $DATABASE_LOADED == true
		ActiveRecord::Base.remove_connection
		$DATABASE_LOADED = false
	end
end

# A cucumber task to stop selfmodifier
When /^selfmodifier is stopped$/ do
	kill_selfmodifier
end

# Run selfmodifier
When /^selfmodifier runs$/ do
	fork_selfmodifier
end

# A cucucmber task to load in the database
When /^the database is loaded$/ do
	require "selfmodifier/database"
	$DATABASE_LOADED = true
end

# A cucumber task to remove the database connection
When /^the database is unloaded$/ do
	ensure_unload_database
end

# Make sure the database is cleaned before we start
Before do
	system "rm selfmodifier.sqlite3.db"
	system "rake db:migrate"
end

# Make sure the server is stopped
After do
	kill_selfmodifier
	unload_database
end
