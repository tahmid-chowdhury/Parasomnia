extends StaticBody2D

@onready var npc_node = self
@export var player_node: Node2D
@export var unique_text = ["The warmth consumes you. You will [color=purple]remember[/color] being here. "]


func _ready() -> void:
	if player_node == null:
		var root = get_tree().get_current_scene()
		player_node = root.find_child("Player", true, false)
		set_process(true)

func _process(delta: float) -> void:
	if player_node == null:
		return
	var distance = npc_node.global_position.distance_to(player_node.global_position)
	if Input.is_action_just_pressed("z"):
		if distance < 20 :
			generate_unique_test()
			save_data()
			

func generate_unique_test():
	for text in unique_text:
		TextBox.queue_text(text)

func save_data():
	if player_node.has_method("save_location"):
		player_node.call("save_location")
