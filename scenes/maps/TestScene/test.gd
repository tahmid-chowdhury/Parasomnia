extends Node2D 

@onready var player: Node2D = $Player
@onready var battle_trigger: Area2D = $BattleTrigger
@onready var sword_sprite: Sprite2D = $Area2D/Sword  

func _ready() -> void:
	if GameState.last_position != Vector2.ZERO:
		player.global_position = GameState.last_position

	if GameState.battle_trigger_used and is_instance_valid(battle_trigger):
		battle_trigger.queue_free()
		sword_sprite.queue_free()
