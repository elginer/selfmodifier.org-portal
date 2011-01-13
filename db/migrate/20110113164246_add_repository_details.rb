class AddRepositoryDetails < ActiveRecord::Migration
	def self.up
		add_column :repositories, :description, :string, :default => ""
		add_column :repositories, :updated, :time
	end

	def self.down
		remove_column :repositores, :description
		remove_column :repositores, :updated
	end
end
