class Group < ActiveRecord::Base
	belongs_to :character
	belongs_to :team
	#has_many :characters
	#has_many :teams
end