require "selfmodifier/models/moderator"

# Login
def login sel
	puts "Initial cookies:"
	puts sel.cookies
	begin
		sel.open "/user/moderation"
	rescue Selenium::CommandError

	end
	puts "Open cookies:"
	puts sel.cookies
	sel.type "username", $user
	sel.type "password", $password
	sel.click "login"
	sel.wait_for_page 10
	puts "Login cookies:"
	puts sel.cookies
end

Given /^the moderator name is "([^"]*)" and their password is "([^"]*)"$/ do |username, password|
	$user = username
	$password = password
end

When /^a new moderator is registered$/ do
	unless system("rake db:create_moderator USER=#$user PASSWORD=#$password")
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
		login sel
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
		login sel
		sel.click "delete"
		puts "delete cookies:"
		puts sel.cookies
		sel.wait_for_page 10
		if sel.title == "selfmodifier.org - Access Denied"
			raise "Couldn't delete repository."
		end
	end
end

When /^the moderator logs in over the web, and then logs out, and then browses to "([^"]*)", and receives an error$/ do |url|
	with_selenium do |sel|
		login sel
		sel.click "logout"
		sel.wait_for_page 10
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
end
