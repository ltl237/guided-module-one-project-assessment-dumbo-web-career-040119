require_relative '../config/environment'
require 'tty-prompt'
#pputs "Hi, Welcome to my game"

$character_list = ["Captain America", "Black Panther", "Doctor Strange", "Scarlett Witch", "Thor", "Loki", "Iron Man", "Spider-Man", "Captain Marvel", "Hawkeye"]

def create_group(char_id, team_id)
	Group.create(character_id: char_id, team_id: team_id)
end

def create_team
	system "clear"
	thanos = Character.find_by(char_name: "Thanos")
	team_array = []
	my_team_atk = 0
	puts "Please enter your team name that will fight #{thanos.char_name}"
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
	char_id = Character.find_by(char_name: character_name).id
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
		group.save
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


def view_single_team(single_team)
	# available_chars = $character_list
	available_chars = []
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
	

	char_names_in_team << "-Back"
	char_to_change = $prompt.select("Substitute Character ?", [char_names_in_team])
	# binding.pry
	if char_to_change == "-Back"
		system "clear"
		view_teams
	else
		char_names_in_team.delete("-Back")
		$character_list.map do |charname|
			if char_names_in_team.include?(charname)

			else
				available_chars << charname
			end

		end
		# char_names_in_team.each do |charname|
		# 	if $character_list.include?(charname) 
		# 	# binding.pry
		# 		available_chars.delete(charname)
		# 	end
		# end
		# binding.pry
		change_char(char_to_change,single_group[0].team_id,single_group[0].id,available_chars)
	end
	# if yn == "Yes"
		# char_to_change = $prompt.select("Substitute Character ?", [chars_in_team_instances.map do |char_inst| char_inst[0].char_name end])
	# elsif yn == "No"
	# 	view_teams
	# end
	
	#p Character.find_by(id: single_group.character_id)
end

def view_teams
	system "clear"
	team_lst = []
	Group.all.map do |group|
		team_lst << Team.find_by(id: group.team_id)
	end
	# team_lst.uniq
	team_names = team_lst.uniq.map{|team| team.team_name}
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
	else
		delete_team
		team
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
		# binding.pry
		team_selection
	end
end


welcome






