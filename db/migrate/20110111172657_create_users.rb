class CreateUsers < ActiveRecord::Migration
  def self.up
	  create_table :users do |t|
		  t.string :name
		  t.string :password
	  end
  end

  def self.down
  end
end
