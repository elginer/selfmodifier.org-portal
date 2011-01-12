Feature: github interface
	In order to get information about github repositories,
	we need to speak to the server.

	Scenario: query existing repository
		When the github repository elginer/exclamation is queried
		Then the last update time should be 2010-12-12T17:27:34-08:00
