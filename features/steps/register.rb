require "selfmodifier/models/user"

When /^the user (.+) registers$/ do |username|
	with_selenium do |sel|
		sel.open "/register"
		sel.type "username-field", username
		sel.type "password-field", "password"
		sel.type "password-check", "password"
		sel.click "Register"
	end
end

Then /^a new user called (.+) has been created$/ do |name|
	unless User.find_by_name(name)
		raise "Could not find user " + name
	end
end
