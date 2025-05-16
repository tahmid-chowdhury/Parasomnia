extends Control


func _ready():
	if ScreenSettings.screen_mode_index != -1:
		ScreenSettings.apply_screen_settings(ScreenSettings.screen_mode_index)
	$VBoxContainer/Start.grab_focus()
	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/TestScene/Test.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/userinterfaces/Options_Screen/Options_Screen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
