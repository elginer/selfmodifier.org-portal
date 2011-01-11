Feature: registration
	Users will want to register on selfmodifier.org so they can upload their code.

	Scenario: successful registration
		When selfmodifier runs
		When the user bob registers
		When selfmodifier is stopped
		When the database is loaded
		Then a new user called bob has been created

	Scenario: unsuccessful registration
		When selfmodifier runs
		When the user bob registers
		When selfmodifier is stopped
		When the database is loaded
		Then a new user called bob has been created
		Then the time of creation of the user bob is logged
		When the database is unloaded
		When selfmodifier runs
		When the user bob registers
		When the database is loaded
		Then the time of creation of the user bob remains unchanged
