extends Node

var screen_mode_index: int = -1

func _ready():
		apply_screen_settings(0)
		
func apply_screen_settings(index: int) -> void:
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

	screen_mode_index = index
