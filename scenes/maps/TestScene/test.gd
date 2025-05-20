extends Node2D

@onready var player: Node2D = $Player

func _ready() -> void:
	if GameState.last_position != Vector2.ZERO:
		player.global_position = GameState.last_position
	
