require "sinatra/base"

module SelfModifier

	# Lightweight cron jobs that run within the server
	#
	# User cron jobs should inherit from Cron
	class Cron

		# The Cron class holds an array of strings representing job classes
		# We can't just hold onto the job classes, because the reference we have to them may not be fully defined.
		@metajobs = []

		# A new cron job was created
		def self.inherited job 
			Cron.more_work job
		end

		# Add a new job to the Cron class
		def Cron.more_work job
			@metajobs.push job.to_s
		end

		# Fork a cron thread
		# Tell the jobs to execute, every minute
		def Cron.fork
			# Convert the metajobs to actual jobs
			jobs = @metajobs.map {|meta| eval "#{meta}.new"}
			Thread.fork do
				loop do
					jobs.each do |job|
						puts "Running minicron job: #{job.class}"
						begin
							job.run
						rescue Exception => e
							puts e.message
							puts e.backtrace
						end
					end
					sleep 60
				end
			end
		end

		#@abstract
		# Run this cron job
		def run
		end
	end
	
end
