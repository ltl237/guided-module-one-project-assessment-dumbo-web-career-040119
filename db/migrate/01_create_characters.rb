class CreateCharacters < ActiveRecord::Migration[5.2]
	def change
		create_table :characters do |t|
			t.string :char_name
			t.integer :char_atk
		end
	end

end
