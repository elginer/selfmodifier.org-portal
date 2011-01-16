Feature: moderators
	As the web master running this site, I might need to prune the list
	occasionally.  I want to do this without having to log in via ssh.

	Scenario: new moderator
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When the database is loaded
		Then the moderator can log in

	# Do we need this?
	Scenario: prevent unauthorized low-level log in, database unpopulated
		Given the moderator name is "samuel" and their password is "beans"
		When the database is loaded
		Then the moderator can not log in

	Scenario: prevent unauthorized low-level log in, database populated
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		Given the moderator name is "samuel" and their password is "beans"
		When the database is loaded
		Then the moderator can not log in

	Scenario: web based log-in
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When selfmodifier runs
		When the moderator logs in over the web
		Then the title of the page is "selfmodifier.org - Welcome bob"

	Scenario: prevent unauthorized web-based log-in
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When selfmodifier runs
		Given the moderator name is "sam" and their password is "awesome"
		When the moderator logs in over the web
		Then the title of the page is "selfmodifier.org - Access denied"

	Scenario: log in required to see restricted area
		When selfmodifier runs
		When the user cookie is deleted
		Then the user browses to "/user/moderation", and receives an error

	Scenario: delete repository
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When selfmodifier runs
		Then a github repository, elginer/exclamation is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for elginer/exclamation is in the database
		When the database is unloaded
		When selfmodifier runs
		When the moderator deletes a repository
		When selfmodifier is stopped
		When the database is unloaded
		When the database is loaded
		Then a repository for elginer/exclamation is not in the database
