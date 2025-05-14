extends Node

var altered_player_index = -1

const base_party_members = [
	{
		"name": "Hero",
		"hp": 100,
		"max_hp": 100,
		"mana": 10,
		"strength": 100,
		"defense": 5,
		"speed": 5,
		"level": 1,
		"xp": 0,
		"xp_required": 100,
		"move": "idle",
	},
	{
		"name": "Mage",
		"hp": 100,
		"max_hp": 100,
		"mana": 100,
		"strength": 12,
		"defense": 5,
		"speed": 7,
		"level": 1,
		"xp": 0,
		"xp_required": 100,
		"move": "idle",
	}
]

var party_members = []

func _ready():

	randomize()
	load_party()
	
	if party_members.size() == 0:
		party_members = base_party_members.duplicate(true)
	else:
		pass


func level_up_stats(Leveled_Player: String, xp_amount: int):
	var party_member = find_party_member(Leveled_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1

	party_members[party_member]["xp"] += xp_amount
	while party_members[party_member]["xp"] >= party_members[party_member]["xp_required"]:
		print("%s has levelled up to level %d" % [party_members[party_member]["name"], party_members[party_member]["level"]])

		var old_xp_required = party_members[party_member]["xp_required"]

		for stat in party_members[party_member]:
			if stat in ["name", "level", "xp", "xp_required"]:
				continue
			if typeof(party_members[party_member][stat]) == TYPE_INT:
				party_members[party_member][stat] += randi_range(1, 3)

		party_members[party_member]["level"] += 1
		party_members[party_member]["xp"] -= old_xp_required
		party_members[party_member]["xp_required"] = int(1.2 * old_xp_required)
	save_party()
	return


func heal_player(Heal_Player: String, Heal_Amount: int):
	var party_member = find_party_member(Heal_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1
	party_members[party_member]["hp"] = min(party_members[party_member]["hp"] + Heal_Amount, party_members[party_member]["max_hp"])
	return party_members[party_member]["hp"]


func damage_player(Damage_Player: String, Damage_Taken: int):
	var party_member = find_party_member(Damage_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1
	party_members[party_member]["hp"] = max(party_members[party_member]["hp"] - Damage_Taken, 0)
	return party_members[party_member]["hp"]


func find_party_member(indicated_party_member: String):
	for party_member in range(party_members.size()):
		if party_members[party_member]["name"] == indicated_party_member:
			altered_player_index = party_member
			return altered_player_index
	return -1


func get_random_alive_member() -> int:
	var alive_members = []
	for party_member in range(party_members.size()):
		if party_members[party_member]["hp"] > 0:
			alive_members.append(party_member)
	if alive_members.is_empty():
		return -1
	return alive_members[randi() % alive_members.size()]

func load_party():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var result = JSON.parse_string(content)
		if result and typeof(result) == TYPE_DICTIONARY and result.has("party_members"):
			party_members = result["party_members"]
			return
	party_members = base_party_members.duplicate(true)

func save_party():
	var save_data = {
		"party_members": party_members
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func set_stats(player_name: String = "Hero", stats: Dictionary = {
	"level": 1,
	"hp": 40,
	"mana": 1,
	"strength": 3,
	"xp": 0,
	"xp_required": 250
}) -> void:
	var index = find_party_member(player_name)
	if index == -1:
		print("No Party Member Found")
		return
	
	for key in stats:
		if party_members[index].has(key):
			party_members[index][key] = stats[key]
		else:
			print("Invalid stat key: %s" % key)
	
	save_party()
	print("Stats updated for %s: %s" % [player_name, stats])

func start_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/battlelocations/BattleLocationTest.tscn")
