require "selenium/client"

# Run a command within a selenium session
def with_selenium
	host = IO.popen("hostname").read.chomp
	browser = Selenium::Client::Driver.new :host => "localhost",
		:port => 4444,
		:browser => "*firefox",
		:url => "http://#{host}:4567",
		:timeout_in_second => 60
	browser.start_new_browser_session
	begin
		yield browser
	ensure
		browser.close_current_browser_session
	end
end
