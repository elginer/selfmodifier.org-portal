Feature: add repository
	In order for people to find interesting source code repositories,
	someone is going to have to add them.

	Scenario: add github repository
		When selfmodifier runs
		Then a github repository, elginer/exclamation is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for elginer/exclamation is in the database

	# There was a bug, so this checks it was fixed
	Scenario: two repositories by same user
		When selfmodifier runs
		Then a github repository, elginer/exclamation is added
		Then a github repository, elginer/carps is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for elginer/exclamation is in the database
		Then a repository for elginer/carps is in the database

	Scenario: non-existent repository
		When selfmodifier runs
		Then a github repository, elginer/cooooooooool is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for elginer/cooooooooool is not in the database

	Scenario: invalid github repository information
		When selfmodifier runs
		Then a github repository, .awesome!/../cool.html is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for .awesome!/../cool.html is not in the database
