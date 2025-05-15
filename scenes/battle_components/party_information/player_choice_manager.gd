extends Node

signal player_choice(value)


func send_character_choice(choice: String):
	emit_signal("player_choice", choice)

func _on_attack_pressed() -> void:
	send_character_choice("Attack")


func _on_defend_pressed() -> void:
	send_character_choice("Defend")
	

func _on_magic_pressed() -> void:
	send_character_choice("Magic")
