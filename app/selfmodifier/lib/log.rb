# Pass a block, run it, log all errors when it runs
def with_logging
	begin
		yield
	rescue Exception => e
		STDERR.puts Time.now
		STDERR.puts e.message
		STDERR.puts e.backtrace
		false
	end
end

# Log an error message
def log_error string
	STDERR.puts Time.now
	STDERR.puts string
end

# Just log
def log status 
	puts Time.now
	puts status
end
