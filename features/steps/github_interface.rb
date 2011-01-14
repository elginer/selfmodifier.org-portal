require "selfmodifier/lib/github_interface"

require "date"

Given /^the github repository is (.+)\/(.+)$/ do |user, project|
	$repo = GitHubInterface.new user, project
end

When /^the repository is queried$/ do
	$request_ok = $repo.send :web_request
end

Then /^the query should return false$/ do
	if $request_ok
		raise "The query returned #{$request_ok}"
	end
end

Then /^the last update time should be "([^"]*)"$/ do |time_str|
	should = DateTime.parse(time_str).to_time
	unless $repo.send(:push_time) == should
		raise "repository was updated at #{$repo.push_time}"
	end
end

Then /^the description should be "([^"]*)"$/ do |about|
	unless $repo.send(:description) == about
		raise "repository description was #{repo.description}"
	end
end
