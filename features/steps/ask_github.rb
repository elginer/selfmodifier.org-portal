require "selfmodifier/cron/github_asker.rb"

class MockGitHubInterface

	# Note that we've asked about this repository 
	def write_details repository
		$unqueried.delete repository
		$total_requests += 3
	end

end

# Cripple network communication for GitHubAsker
class MockAsker < GitHubAsker

	def initialize all
		@all = all
		@github = MockGitHubInterface.new
		reset
	end

	def run
		super
	end

	protected

	def fetch_repositories
		@all
	end

end

Given /^a github asker with (\d+) repositories$/ do |fakers|
	n = fakers.to_i
	$all = Set.new 1..n
	$unqueried = $all.clone
	$asker = MockAsker.new $all
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
