class Character < ActiveRecord::Base
	#belongs_to :group#, through: :createteams
	has_many :groups
	has_many :teams, through: :groups
end
