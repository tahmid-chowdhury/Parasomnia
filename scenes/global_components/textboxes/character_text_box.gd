extends CanvasLayer

@onready var Textbox_Container = get_node("Textbox_Container")
@onready var TextInput = get_node("Textbox_Container/MarginContainer/Panel/TextInput")

var displaying = false
var TextTween
var current_state = State.READY
const Char_read_rate = 0.05
var text_queue = []

enum State {
	READY,
	READING,
	FINISHED
}

func _ready() -> void:
	if text_queue.is_empty():
		hide_textbox()

	TextInput.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	TextInput.bbcode_enabled = true
	TextInput.fit_content = false

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("z"):
				TextInput.visible_ratio = 1.0
				if TextTween:
					TextTween.kill()
				change_text_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("z"):
				if text_queue.is_empty():
					hide_textbox()
				reset_textbox()
				displaying = false
				change_text_state(State.READY)

func queue_text(next_text):
	if !is_displaying():
		text_queue.push_back(next_text)

func reset_textbox():
	TextInput.text = ""

func show_textbox():
	Textbox_Container.show()

func hide_textbox():
	TextInput.text = ""
	Textbox_Container.hide()

func clear_textbox():
	text_queue.clear()
	hide_textbox()

func display_text():
	var display_text = text_queue.pop_front()
	TextInput.bbcode_enabled = true
	TextInput.text = display_text
	TextInput.visible_ratio = 0.0
	change_text_state(State.READING)
	show_textbox()
	TextTween = create_tween()
	TextTween.tween_property(TextInput, "visible_ratio", 1.0, len(display_text) * Char_read_rate)
	await TextTween.finished
	change_text_state(State.FINISHED)
	await get_tree().create_timer(0.3).timeout

func change_text_state(next_state):
	current_state = next_state

func is_displaying():
	displaying = TextInput.text != ""
	return displaying
