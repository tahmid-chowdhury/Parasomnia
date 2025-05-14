extends Area2D
@export var trigger_id: String = ""
@export var player_node: Node2D

@onready var enemy_node = self

signal player_contact(player)

@export var enemy_group: Array = [{
	"enemy_id": 1,
	"name": "Test",
	"enemy_health": 5,
	"speed": 3,
	"enemy_power": 12,
	"given_xp": 1000
},
{
	"enemy_id": 2,
	"name": "Test2",
	"enemy_health": 5,
	"speed": 6,
	"enemy_power": 2,
	"given_xp": 1000
	}
	]

func _process(delta: float) -> void:

	var distance = self.global_position.distance_to(player_node.global_position)
	if distance < 500:
		move_towards_player(delta)

func _ready() -> void:
	set_meta("trigger_id", trigger_id)
	if trigger_id in GameState.enemy_last_positions:
		global_position = GameState.enemy_last_positions[trigger_id]
	player_node = get_tree().get_current_scene().get_node_or_null("Player")
	set_process(true)
	

	if trigger_id in GameState.used_triggers:
		queue_free()
		return
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is Player:
		save_enemy_positions()
		set_deferred("monitoring", false)
		set_deferred("collision_layer", 0) 
		set_deferred("collision_mask", 0)  
		queue_free() 
		GameState.used_triggers.append(trigger_id)
		GameState.last_position = body.global_position
		EnemyManager.add_enemy_group(enemy_group)
		PartyManager.call_deferred("start_battle")

func move_towards_player(delta: float):
	var direction = (player_node.global_position - enemy_node.global_position).normalized()
	enemy_node.global_position += direction * 30 * delta
	
func save_enemy_positions():
	var parent = get_parent()
	for node in parent.get_children():
		if node is Area2D and node != self and node.has_meta("trigger_id"):
			var id = node.get_meta("trigger_id")
			GameState.enemy_last_positions[id] = node.global_position
	
	
	
