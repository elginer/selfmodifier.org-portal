require "socket"

ROOT = File.dirname(__FILE__) + "/../../"

$:.unshift ROOT + "/app"

module SelfModifier
end

include SelfModifier

def fork_process file 
	fork do
		Process.setsid
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
	$SERVER_PID = fork_process "run"
	wait_connect "4567"
	$SELENIUM_PID = fork_process "run_selenium"
	wait_connect "4444"
end

# Stop running a process
def kill pid
	if pid
		Process.kill "TERM", -Process.getpgid(pid)
		Process.wait pid
	end
end

# Stop running self modifier
def kill_selfmodifier
	kill $SELENIUM_PID
	$SELENIUM_PID = nil
	kill $SERVER_PID
	$SERVER_PID = nil
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
