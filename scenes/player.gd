extends CharacterBody2D

# Runs once at startup
#func _ready():
	#...

# Runs every frame
func _process(delta: float) -> void:
	# Move position
	#position.x += 1
	#position.y += 1
	
	if Input.is_action_pressed("ui_right"):
		position.x += 1
	if Input.is_action_pressed("ui_left"):
		position.x -= 1
	if Input.is_action_pressed("ui_up"):
		position.y -= 1
	if Input.is_action_pressed("ui_down"):
		position.y += 1
	
	pass
