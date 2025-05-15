extends Node

var enemies = [
]
var enemy_index = -1

	
func _ready():
	randomize()
	

	
func damage_enemy(selected_enemy: int, damage_dealt: int):
	enemy_index = find_enemy(selected_enemy)
	if enemy_index == -1:
		print("No Enemy Found")
		return -1
	enemies[enemy_index]["enemy_health"] = max(enemies[enemy_index]["enemy_health"] - damage_dealt, 0)
	if enemies[enemy_index]["enemy_health"] == 0:
		enemies.remove_at(enemy_index)
		return 0
	return enemies[enemy_index]["enemy_health"]
			
func find_enemy(selected_enemy: int):
	for enemy in range(enemies.size()):
		if enemies[enemy]["enemy_id"] == selected_enemy:
			return enemy
	return -1
	
func place_enemies():
	for i in range(enemies.size()):
		var enemy_data = enemies[i]
		var sprite_path = "res://scenes/characters/enemies/Dream 1/%s.png" % enemy_data["name"]

		if ResourceLoader.exists(sprite_path):
			var sprite = Sprite2D.new()
			sprite.texture = load(sprite_path)
			sprite.position = Vector2(160, i * 100)
			add_child(sprite)

			enemy_data["sprite_node"] = sprite
		else:
			print("Sprite not found for: ", enemy_data["name"])

			
		
		
	
func add_enemy_group(enemy_group: Array):
	for i in range(enemy_group.size()):
		enemies.append(enemy_group[i])		
		
	
