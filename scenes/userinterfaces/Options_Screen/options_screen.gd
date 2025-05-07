extends Control

func _ready():
	if ScreenSettings.screen_mode_index != -1:
		ScreenSettings.apply_screen_settings(ScreenSettings.screen_mode_index)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_screen_size_options_item_selected(index: int) -> void:
	var current_screen := DisplayServer.window_get_current_screen()
	DisplayServer.window_set_current_screen(current_screen)

	match index:
		0:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))

		1:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var screen_size := DisplayServer.screen_get_size(current_screen)
			var screen_pos := DisplayServer.screen_get_position(current_screen)
			DisplayServer.window_set_size(screen_size)
			DisplayServer.window_set_position(screen_pos)

		2:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	ScreenSettings.screen_mode_index = index


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/userinterfaces/Main_Menu_Screen/Main_Menu.tscn")
