extends StaticBody2D

@onready var npc_node = self
@export var player_node: Node2D
@export var unique_text = ["Hello, I am the generated text!", "Hello, I am the generated text second box!" ]

var has_queued: bool = false
var cooldown_active: bool = false
@export var cooldown_time: float = 2.0
var cooldown_timer: float = 0.0

func _ready() -> void:
	if player_node == null:
		var root = get_tree().get_current_scene()
		player_node = root.find_child("Player", true, false)
	set_process(true)

func _process(delta: float) -> void:
	if player_node == null:
		return
		
	var distance = npc_node.global_position.distance_to(player_node.global_position)

	if has_queued and not cooldown_active and not TextBox.is_displaying():
		cooldown_active = true
		cooldown_timer = 0.0

	if cooldown_active:
		cooldown_timer += delta
		if cooldown_timer >= cooldown_time:
			has_queued = false
			cooldown_active = false
			cooldown_timer = 0.0

	if Input.is_action_just_pressed("z") and distance < 20 and not has_queued:
		generate_unique_test()
		has_queued = true

func generate_unique_test():
	for text in unique_text:
		TextBox.queue_text(text)

func save_location():
	if player_node.has_method("save_location"):
		player_node.call("save_location")
