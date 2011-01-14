Feature: github interface
	In order to get information about github repositories,
	we need to speak to the server.

	Scenario: query existing repository
		Given the github repository is elginer/exclamation
		When the repository is queried
		Then the last update time should be "2010/12/12 17:27:09 -0800"
		Then the description should be "Generates a fractal zoom of an exclamation mark and sends it stdout.  Nifty!"

	Scenario: query non existent repository
		Given the github repository is elginer/nothere
		When the repository is queried
		Then the query should return false
