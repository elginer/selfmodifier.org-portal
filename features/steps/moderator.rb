require "selfmodifier/models/moderator"

Given /^the moderator name is "([^"]*)" and their password is "([^"]*)"$/ do |username, password|
	$user = username
	$password = password
end

When /^a new moderator is registered$/ do
	unless system("rake new_moderator user=#$user password=#$password")
		raise "Could not create new moderator!"
	end
end

Then /^the moderator can log in$/ do
	mod = Moderator.authenticate $user, $password
	unless mod
		raise "Moderator could not log in!"
	end
end

Then /^the moderator can not log in$/ do
	mod = Moderator.authenticate $user, $password
	if mod
		raise "Moderator could log in!"
	end
end

When /^the moderator logs in over the web$/ do
	with_selenium do |sel|
		sel.open "/login"
		sel.type "username", $user
		sel.type "password", $password
		sel.click "log in"
		sel.wait_for_page 10
		$title = sel.title
	end
end

Then /^the title of the page is "([^"]*)"$/ do |actual|
	$title.should eql actual
end

When /^the user browses to "([^"]*)"$/ do |addr|
	with_selenium do |sel|
		sel.open addr
		$title = sel.title
	end
end
