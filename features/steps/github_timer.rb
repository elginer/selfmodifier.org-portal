require "selfmodifier/cron/github_timer.rb"

# The github interface is associated with a unique number in our system
# This means we can keep track of which repositories we have updated
class MockGitHubInterface

	def initialize n
		@num = n
	end

	# Note that we've asked about this repository 
	def update! 
		$unqueried.delete @num
		$total_requests += 1
	end

end

# Cripple network communication for GitHubTimer
class GitHubTimer

	def fetch_repositories
		$all.map {|rep| MockGitHubInterface.new rep}
	end

end

Given /^a github asker with (\d+) repositories$/ do |fakers|
	n = fakers.to_i
	$all = Set.new 1..n
	$unqueried = $all.clone
	$asker = GitHubTimer.new
	$total_requests = 0
end

When /^it asks github for information$/ do
	$asker.run
end

Then /^(\d+) repositories remain unqueried$/ do |needed|
	unless needed.to_i == $unqueried.size
		raise "#{$unqueried.size} repositories remain unqueried"
	end
end

Then /^(\d+) requests were made altogether$/ do |needed|
	unless needed.to_i == $total_requests
		raise "There were #{$total_requests} in total"
	end
end

Then /^it is run by the cron system (\d+) times$/ do |executions|
	executions.to_i.times do
		$asker.run
	end
end

When /^all repositires are switched to unqueried$/ do
	$unqueried = $all.clone	
end
