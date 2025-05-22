extends Node

var Turn_Array = []
var Attack_Commads = ["Attack", "Magic"]
var turn_index: int = 0
var total_xp_gain = 0

@onready var battle_location = get_tree().get_current_scene()
@onready var character_choice_manager = $"../CanvasLayer/Control"

func _ready() -> void:
	create_turn_order()
	process_and_reset_turns()
	if Turn_Array.size() < 2:
		end_victory()

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
		var choice = await character_choice_manager.player_choice

		var index = -1
		for i in range(PartyManager.party_members.size()):
			if PartyManager.party_members[i]["name"] == attacker["name"]:
				index = i
				break

		PartyManager.party_members[index]["move"] = choice

		if choice in Attack_Commads and EnemyManager.enemies.size() > 0:
			var target_index = character_choice_manager.selected_enemy_index

			if target_index < 0 or target_index >= EnemyManager.enemies.size() \
			or EnemyManager.enemies[target_index]["enemy_health"] <= 0:
				print("Invalid or dead target. Ending turn.")
				turn_index += 1
				process_and_reset_turns()
				return

			var target_enemy = EnemyManager.enemies[target_index]
			var damage = calculate_damage(choice, index)
			target_enemy["enemy_health"] = max(target_enemy["enemy_health"] - damage, 0)
			print("%s attacked %s for %.1f damage" % [attacker["name"], target_enemy["name"], damage])

			if target_enemy["enemy_health"] == 0:
				if is_instance_valid(battle_location.selector):
					battle_location.selector.visible = false

				if target_enemy.has("sprite_node") and is_instance_valid(target_enemy["sprite_node"]):
					
					var sprite = target_enemy["sprite_node"]
					sprite.remove_from_group("battle_enemies")
					sprite.queue_free()

				total_xp_gain += target_enemy["given_xp"]

				for i in range(Turn_Array.size()):
					if Turn_Array[i] == target_enemy:
						Turn_Array.remove_at(i)
						break

				EnemyManager.enemies.remove_at(target_index)

				if is_instance_valid(battle_location) and battle_location.has_method("refresh_after_enemy_removed"):
					await battle_location.refresh_after_enemy_removed()

			if EnemyManager.enemies.size() == 0:
				end_victory()
				return
	battle_location.emit_signal("update_bars")
	turn_index += 1
	process_and_reset_turns()

func add_party():
	for member in PartyManager.party_members:
		if member["hp"] > 0:
			member["type"] = "player"
			Turn_Array.append(member)

func add_enemies():
	for enemy in EnemyManager.enemies:
		if enemy["enemy_health"] > 0:
			enemy["type"] = "enemy"
			Turn_Array.append(enemy)

func end_fight():
	Turn_Array.clear()
	print("All party Members have died")
	GameState.StartFromSave = true
	get_tree().change_scene_to_file("res://scenes/userinterfaces/Main_Menu_Screen/Main_Menu.tscn")

func end_victory():
	Turn_Array.clear()
	print("All enemies defeated! You win!")
	for member in PartyManager.party_members:
		PartyManager.level_up_stats(member["name"], total_xp_gain)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/maps/TestScene/Test.tscn")


func calculate_damage(Attack_Choice: String, Player_Index: int):
	if Attack_Choice == "Attack":
		return PartyManager.party_members[Player_Index]["strength"] * 0.6
	return PartyManager.party_members[Player_Index]["mana"] * 0.6
