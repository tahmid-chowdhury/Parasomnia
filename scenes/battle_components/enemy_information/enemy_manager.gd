extends Node

var enemies = [{
	"enemy_id": 1,
	"name": "Test",
	"enemy_health": 5,
	"speed": 3,
	"enemy_power": 12
},
{
	"enemy_id": 2,
	"name": "Test2",
	"enemy_health": 5,
	"speed": 6,
	"enemy_power": 2
	}
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
	pass
	
