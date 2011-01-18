class RepositoryDatetime < ActiveRecord::Migration
  def self.up
	  remove_column :repositories, :updated
	  add_column :repositories, :updated, :datetime
  end

  def self.down
	  remove_column :repositories, :updated
	  add_column :repositories, :updated, :time
  end
end
