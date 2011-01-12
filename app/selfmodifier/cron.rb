require "sinatra/base"

module SelfModifier

	# Lightweight cron jobs that run within the server
	#
	# User cron jobs should inherit from Cron
	class Cron

		# The Cron class holds an array of jobs
		@jobs = []

		# A new cron job was created
		def self.inherited klass
			job = klass.new 
			Cron.more_work job
		end

		# Add a new job to the Cron class
		def Cron.more_work job
			@jobs.push job
		end

		# Fork a cron thread
		# Tell the jobs to execute, every minute
		def Cron.fork
			# If we're in development mode,
			# then crash the whole app when this thread crashes.
			if Sinatra::Base.development?
				Thread.abort_on_exception = true
			end
			Thread.fork do
				loop do
					@jobs.each do |job|
						puts "Running minicron job: #{job.class}"
						job.run
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
