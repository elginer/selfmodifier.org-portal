class CreateModerator < ActiveRecord::Migration
  def self.up
	  create_table :moderators do |t|
		  t.string "username"
		  t.string "password"
	  end

  end

  def self.down
	  drop_table :moderators
  end
end
