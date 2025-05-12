extends Node

signal player_choice(value)

func _ready() -> void:
	print("Hey its my turn")
	
func send_character_choice(Choice: String):
	print("Sending over attack")
	emit_signal("player_choice", Choice)
	print("sending over attack")
	

func _on_attack_pressed() -> void:
	print("attack prssed")
	send_character_choice("Attack")
