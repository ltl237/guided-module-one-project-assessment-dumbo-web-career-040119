class CreateTeams < ActiveRecord::Migration[5.2]
	def change
		create_table :teams do |t|
			t.string :team_name
			t.integer :team_atk
		end
	end
end