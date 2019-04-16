class CreateCharacters < ActiveRecord::Migration[5.2]

	def change
		create_table :teams do |t|
			t.integer :char_id
			t.integer :team_id
		end
	end

end
