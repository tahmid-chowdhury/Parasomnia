extends Control

func _ready() -> void:
	EnemyManager.place_enemies()
	$CanvasLayer/Control/Panel/VBoxContainer/Row1/HBoxContainer/AttackButton.grab_focus()
	
	
func get_character():
	for i in (PartyManager.party_members.size()):
		pass
		
