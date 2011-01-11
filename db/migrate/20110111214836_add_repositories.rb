class AddRepositories < ActiveRecord::Migration
  def self.up
	  create_table :repositories do |t|
		  t.string "user"
		  t.string "project"
	  end
  end

  def self.down
	  drop_table :repositories
  end
end
