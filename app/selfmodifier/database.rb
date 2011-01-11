# Use activerecord
require "active_record"

ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:database => "selfmodifier.sqlite3.db"
)
