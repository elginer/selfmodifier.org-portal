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
		sel.open "/user/login"
		sel.type "username", $user
		sel.type "password", $password
		sel.click "login"
		sel.wait_for_page 10
		$title = sel.title
	end
end

Then /^the title of the page is "([^"]*)"$/ do |should|
	unless $title == should 
		raise "The title was #$title"
	end
end

When /^the user browses to "([^"]*)"$/ do |addr|
	with_selenium do |sel|
		sel.open addr
		$title = sel.title
	end
end

Then /^the user browses to "([^"]*)", and receives an error$/ do |url|
	authenticated = false
	with_selenium do |sel|
		begin
			sel.open url
		rescue Selenium::CommandError => e
			authenticated = false
		end
	end
	if authenticated
		raise "Unauthorized user logged in!"
	end
end


When /^the moderator deletes a repository$/ do
	with_selenium do |sel|
		sel.open "/user/login"
		sel.type "username", $user
		sel.type "password", $password
		sel.click "login"
		sel.wait_for_page 10		
		sel.click "delete"
		sel.wait_for_page 10
	end
end

When /^the user cookie is deleted$/ do
	with_selenium do |sel|
		sel.delete_cookie "user", "domain=#{hostname}, path=/"
	end
end
