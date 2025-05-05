extends CharacterBody2D

func helloWorld():
	print("Hello World!")

# Runs once at startup
func _ready():
	helloWorld()

# Runs every frame
func _process(delta: float) -> void:
	print("test")
