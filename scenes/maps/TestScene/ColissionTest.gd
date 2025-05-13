extends Area2D

signal player_contact(player)

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is Player and not GameState.battle_trigger_used:
		GameState.battle_trigger_used = true
		GameState.last_position = body.global_position
		get_tree().change_scene_to_file("res://scenes/maps/battlelocations/BattleLocationTest.tscn")
