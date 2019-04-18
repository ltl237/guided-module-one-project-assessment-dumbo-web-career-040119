require_relative '../config/environment'
require 'tty-prompt'
#pputs "Hi, Welcome to my game"
#Group.where(team_id: team_id).map{|group| puts Character.find_by(id: group.character_id).char_name}
#^finding all characters in a specific team through group
$character_list = ["Captain America", "Black Panther", "Doctor Strange", "Scarlett Witch", "Thor", "Loki", "Iron Man", "Spider-Man", "Captain Marvel", "Hawkeye"]

def create_group(char_id, team_id)
	Group.create(character_id: char_id, team_id: team_id)
end

def create_team
	system "clear"
	thanos = Character.find_by(char_name: "Thanos")
	team_array = []
	my_team_atk = 0
	puts "Please enter your team name that will fight #{thanos.char_name} of 1000 HP"
	my_team_name = gets.chomp
	my_team = Team.create(team_name: my_team_name, team_atk: 0)

	temp_char_list = $character_list
	while team_array.length < 4
		char_selection = $prompt.select("Choose from these characters to form a team of 4: ", $character_list)
		if !team_array.include?(char_selection)
			team_array << char_selection
			
			temp_char_list.delete(char_selection)
		end
	end

	puts "Your Team: #{my_team.team_name} \nconsists of :"

	team_array.each do |character|
		if character == Character.find_by(char_name: character).char_name
				p "#{character}, ATK: #{Character.find_by(char_name: character).char_atk}"
				my_team.team_atk += Character.find_by(char_name: character).char_atk
				# binding.pry
		end
	end

	my_team.save

	team_array.each do |character|
		create_group(Character.find_by(char_name: character).id, my_team.id)
	end
	my_group_arr = Group.where(:team_id => my_team.id)
	# my_group_arr.each do |group|
	# 	#temp_char = Character.find_by(id: group.character_id)
	# 	my_team_atk += Character.find_by(id: group.character_id).char_atk
	# end
	#puts "With #{my_team.team_atk} total hit points \n"	
	team_selection
end

def change_char(character_name,team_id,group_id,available_chars)
	# change_char_list = $character_list
	# binding.pry
	# change_char_list = char_names_in_team
	available_chars
	# binding.pry
	char_id = Character.find_by(char_name:character_name).id
	# binding.pry
	team_to_change = Team.find_by(id: team_id)
	group_to_change = Group.where(team_id: team_id)
	current_char_ids_in_team = group_to_change.map{|group_inst| group_inst.character_id}
	current_char_names_in_team = current_char_ids_in_team.map{|char_id| Character.find_by(id: char_id).char_name}

	# char_names_in_team.each do |charname|
	# 	if $character_list.include?(charname) 
	# 		# binding.pry
	# 		change_char_list.delete(charname)
	# 	end
	# end
	# binding.pry
	sub_with_name = $prompt.select("Who would you like to substitute #{character_name} with ?",[available_chars])
	
	sub_char_id = Character.find_by(char_name: sub_with_name).id

	current_char_names_in_team.map do |charname|
		charname.gsub(character_name,sub_with_name)
	end

	group_to_change.map do |group|
		if group.character_id == char_id
  			# group.character_id = sub_char_id
  			group.update(character_id: sub_char_id)
		end  
	end
	current_char_names_in_team = []

	puts "Here is your new team, #{team_to_change.team_name} "
	group_to_change.each do |group|
		current_char_names_in_team << Character.find_by(id: group.character_id).char_name
		# group.save
		# character_id = Character.find_by(id: group.character_id)
		# binding.pry
	end


	current_char_names_in_team.each do |charname|
		if charname == Character.find_by(char_name: charname).char_name
				p "#{charname}, ATK: #{Character.find_by(char_name: charname).char_atk}"
				team_to_change.team_atk += Character.find_by(char_name: charname).char_atk
				# binding.pry
		end
	end


	# binding.pry
	view_teams
	#puts "With #{team_to_change.team_atk} total hit points \n"

	# team_to_be_changed = 
	# group_to_be_changed = 
end

# def change_char(character)

	
# end
def view_single_team(single_team_string)
	# available_chars = $character_list
	single_team = single_team_string.split(',')[0]
	available_chars = []
	# binding.pry
	single_team_id = Team.find_by(team_name: single_team).id
	single_group = Group.where(team_id: single_team_id)
	chars_in_team_instances = []
	single_group.map do |item_in_group|
			chars_in_team_instances << Character.where(id: item_in_group.character_id)
	end

	# yn = $prompt.select("Substitute Character ?", ["Yes", "No"])
	char_names_in_team = chars_in_team_instances.map do |char_inst| 
		char_inst[0].char_name 
	end
	
	char_names_in_team << "-Fight"
	char_names_in_team << "-Back"

	char_to_change = $prompt.select("Substitute Character ?", [char_names_in_team])
	# binding.pry
	if char_to_change == "-Back"
		system "clear"
		view_teams
	elsif char_to_change == "-Fight"
		system "clear"
		fight(single_team_id)
	else
		char_names_in_team.delete("-Fight")
		char_names_in_team.delete("-Back")
		$character_list.map do |charname|
			if char_names_in_team.include?(charname)

			else
				available_chars << charname
			end

		end
		
		change_char(char_to_change,single_group[0].team_id,single_group[0].id,available_chars)
	end
	
end

def view_teams
	system "clear"
	team_lst = []
	Group.all.map do |group|
		team_lst << Team.find_by(id: group.team_id)
	end
	# team_lst.uniq
	# team_names_hash = {}

	team_names = team_lst.uniq.map do |team| 
		"#{team.team_name}, ATK: #{team.team_atk}"
	end
	team_names << "-Back"

	single_team = $prompt.select("Teams:", [team_names])
	if single_team == "-Back"
		system "clear"
		team_selection

	else
		view_single_team(single_team)
	end
	# team_selection
end


def welcome
	system "clear"
	puts "Hi, Welcome to my game"
	team_selection
end

def team_selection
	$character_list = ["Captain America", "Black Panther", "Doctor Strange", "Scarlett Witch", "Thor", "Loki", "Iron Man", "Spider-Man", "Captain Marvel", "Hawkeye"]
	#puts "Hi, Welcome to my game"

	team = $prompt.select("Select", ["Assemble A New Team", "View Teams", "Delete A Team"])

	if team == "Assemble A New Team"
		create_team
		team
	elsif team == "View Teams"
		view_teams
		team
	elsif team == "Delete A Team"
		delete_team
		team
	# elsif team == "Attack Thanos"
	# 	attack
	# 	team
	end


end

def delete_team
	system "clear"
	team_lst = []
	Group.all.map do |group|
		team_lst << Team.find_by(id: group.team_id)
	end
	# team_lst.uniq
	team_names = team_lst.uniq.map{|team| team.team_name}
	team_names << "-Back"

	team_name_to_delete = $prompt.select("Teams:", [team_names])
	if team_name_to_delete == "-Back"
		system "clear"
		team_selection
	else
		deleted_team_id = Team.find_by(team_name: team_name_to_delete)
		Group.where(team_id: deleted_team_id).destroy_all
		puts "Deleted #{Team.find_by(team_name: team_name_to_delete).team_name}"
		Team.where(id: deleted_team_id).destroy_all
		
		# binding.pry
		team_selection
	end
end

def fight(team_id)
	chars_in_current_team_fighting = Group.where(team_id: team_id).map{|group| Character.find_by(id: group.character_id).char_name}
	thanos = Character.find_by(char_name: "Thanos")
	current_team = Team.find_by(id: team_id)
	puts "#{current_team.team_name} challenges Thanos with the following Avengers:"
	# p chars_in_current_team_fighting

	chars_in_current_team_fighting.each do |charname|
		if charname == Character.find_by(char_name: charname).char_name
				p "#{charname}, ATK: #{Character.find_by(char_name: charname).char_atk}"
				# team_to_change.team_atk += Character.find_by(char_name: charname).char_atk
				# binding.pry
		end
	end

	bonus = ""

	if chars_in_current_team_fighting.include?("Captain America") && chars_in_current_team_fighting.include?("Iron Man")
		current_team.team_atk += 275
		bonus = "CA+IM"
	end
	if chars_in_current_team_fighting.include?("Scarlett Witch") && chars_in_current_team_fighting.include?("Doctor Strange") && chars_in_current_team_fighting.include?("Iron Man")
		current_team.team_atk += 1000
		bonus = "SW+DS+IM"
	end
	if chars_in_current_team_fighting.include?("Thor") && chars_in_current_team_fighting.include?("Captain Marvel")
		current_team.team_atk += 875
		bonus = "T+CM"
		# binding.pry
	end
	puts "===================================================="
	sleep(1)
	# binding.pry
	if current_team.team_atk > thanos.char_atk
		puts "#{current_team.team_name} is victorious against Thanos!"
		puts "Thanks to the #{bonus} combination, #{current_team.team_name} increased their atk powers to #{current_team.team_atk}\n\n"
		puts "===================================================="
	else
		puts "#{current_team.team_name} of #{current_team.team_atk} ATK has been defeated by Thanos!"
		puts "Maybe try a different combination of heroes to challenge the Mad Titan\n\n"
		puts "===================================================="
	end
		team_selection
	# binding.pry
end
	


welcome






