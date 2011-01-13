Feature: github interface
	In order to get information about github repositories,
	we need to speak to the server.

	Scenario: query existing repository
		When the github repository elginer/exclamation is queried
		Then the last update time should be "2010/12/12 17:27:09 -0800"
		Then the description should be "Generates a fractal zoom of an exclamation mark and sends it stdout.  Nifty!"
