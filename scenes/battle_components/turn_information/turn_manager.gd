extends Node

var Turn_Array = []
var turn_index: int = 0
@onready var character_choice_manager = $"../CanvasLayer/Control"

func _ready() -> void:
	create_turn_order()
	process_and_reset_turns()
	
	
func process_and_reset_turns():
	if turn_index >= Turn_Array.size():
		turn_index = 0
	index_turn()
	
	
func create_turn_order():
	turn_index = 0
	Turn_Array.clear()
	add_party()
	add_enemies()
	Turn_Array.sort_custom(func(a, b): return a["speed"] > b["speed"])
	
	
func index_turn():
	var attacker = Turn_Array[turn_index]
	
	if attacker["type"] == "enemy":
		var attacked_index = PartyManager.get_random_alive_member()
		if attacked_index == -1:
			end_fight()
			return

		var attacked_player = PartyManager.party_members[attacked_index]["name"]
		var damage = attacker.get("enemy_power", 5)
		if PartyManager.party_members[attacked_index]["move"] == "Defend":
			damage *= 0.5 
		PartyManager.damage_player(attacked_player, damage)
		print("%s has taken %d damage from %s" % [attacked_player, damage, attacker["name"]])
		
		if PartyManager.party_members[attacked_index]["hp"] == 0:
			for i in range(Turn_Array.size()):
				if Turn_Array[i]["name"] == attacked_player:
					Turn_Array.remove_at(i)
					break

			var alive_left = false
			for p in PartyManager.party_members:
				if p["hp"] > 0:
					alive_left = true
					break
			if not alive_left:
				end_fight()
				return
	else:
		var player_choice = await character_choice_manager.player_choice
		var index = -1
		for i in range(PartyManager.party_members.size()):
			if PartyManager.party_members[i]["name"] == attacker["name"]:
				index = i
				print(index)
				break
		PartyManager.party_members[index]["move"] = player_choice
		
	turn_index += 1
	process_and_reset_turns()
	

func add_party():
	for member in PartyManager.party_members:
		if member["hp"] > 0:
			var full_entry = member.duplicate(true)
			full_entry["type"] = "player"
			Turn_Array.append(full_entry)

func add_enemies():
	for enemy in EnemyManager.enemies:
		if enemy["enemy_health"] > 0:
			var full_entry = enemy.duplicate(true)
			full_entry["type"] = "enemy"
			Turn_Array.append(full_entry)

func end_fight():
	Turn_Array.clear()
	get_tree().change_scene_to_file("res://scenes/maps/TestScene/Test.tscn")
