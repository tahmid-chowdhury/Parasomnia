extends Button

func _ready() -> void:
	hide_hover()
	var empty_stylebox := StyleBoxEmpty.new()
	add_theme_stylebox_override("focus", empty_stylebox)
	connect("focus_entered", Callable(self, "_on_focus_entered"))
	connect("focus_exited", Callable(self, "_on_focus_exited"))

func hide_hover():
	self_modulate = Color("ffffff")

func show_hover():
	self_modulate = Color("ffa141")

func _on_focus_entered() -> void:
	show_hover()

func _on_focus_exited() -> void:
	hide_hover()
