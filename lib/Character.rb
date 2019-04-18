class Character < ActiveRecord::Base
	#belongs_to :group#, through: :createteams
	belongs_to :group
	has_many :teams, through: :groups
end
