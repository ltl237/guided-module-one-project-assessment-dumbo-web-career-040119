class Team < ActiveRecord::Base
	has_many :groups
	has_many :characters, through: :groups
	
end
