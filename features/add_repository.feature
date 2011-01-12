Feature: add repository
	In order for people to find interesting source code repositories,
	someone is going to have to add them.

	Scenario: add github repository
		When selfmodifier runs
		Then a github repository, elginer/exclamation is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for elginer/exclamation is in the database

	Scenario: invalid github repository information
		When selfmodifier runs
		Then a github repository, .awesome!/../cool.html is added
		When selfmodifier is stopped
		When the database is loaded
		Then a repository for .awesome!/../cool.html is not in the database
