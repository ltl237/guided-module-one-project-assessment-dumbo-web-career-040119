class Team < ActiveRecord::Base
	has_many :characters, through: :groups
	belongs_to :group
end
