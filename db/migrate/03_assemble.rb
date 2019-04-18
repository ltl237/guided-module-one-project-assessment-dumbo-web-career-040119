class Assemble < ActiveRecord::Migration[5.2]
	def change
		create_table :groups do |t|
			t.integer :character_id
			t.integer :team_id
		end
	end
end