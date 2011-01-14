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
		Then the title of the page is "Welcome bob"

	Scenario: prevent unauthorized web-based log-in
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When selfmodifier runs
		Given the moderator name is "sam" and their password is "awesome"
		When the moderator logs in over the web
		Then the title of the page is "Access denied"

	Scenario: sessions
		Given the moderator name is "bob" and their password is "cool"
		When a new moderator is registered
		When selfmodifier runs
		When the moderator logs in over the web
		Then the title of the page is "Welcome bob"
		When the user browses to "/repositories/edit"
		Then the title of the page is "Welcome bob"

	Scenario: log in required to see restricted area
		When selfmodifier runs
		When the user browses to "/repositories/edit"
		Then the title of the page is "Access denied"
