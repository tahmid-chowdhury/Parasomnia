extends Area2D

@export var player_node: Node2D
var triggered: bool = false
@export var unique_area_text = []

func _ready() -> void:
	
	if player_node == null:
		var root = get_tree().get_current_scene()
		player_node = root.find_child("Player", true, false)
	
	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body: Node) -> void:
	if body is Player and triggered == false:
		for text in unique_area_text:
			TextBox.queue_text(text)
	triggered = true
	
