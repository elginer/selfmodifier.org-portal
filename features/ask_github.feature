Feature: ask github for information on the repositories
	As a selfmodifier user, I would like to see information
	on the repositories I am browsing.

#	This feature will be implemented as a cron job,
#	and github will only allow 60 requests per minute
#	so these scenarios take this into account.
#	We also require 3 requests for each repository.

	Scenario: 20 repositories
		Given a github asker with 20 repositories
		When it asks github for information
		Then 0 repositories remain unqueried
		Then 60 requests were made altogether

	Scenario: 40 repositories
		Given a github asker with 40 repositories
		When it asks github for information
		Then 20 repositories remain unqueried
		Then it asks github for information
		Then 0 repositories remain unqueried
		Then 120 requests were made altogether

	Scenario: update every hour
		Given a github asker with 40 repositories
		When it asks github for information
		Then 20 repositories remain unqueried
		When it asks github for information
		Then 0 repositories remain unqueried
		# We need to switch these back to support the next cycle
		# NOTE this is cucumber anti pattern!
		# This is an implementation detail
		When all repositires are switched to unqueried
		Then it is run by the cron system 30 times
		When it asks github for information
		Then 20 repositories remain unqueried
		When it asks github for information
		Then 0 repositories remain unqueried
		Then 240 requests were made altogether
