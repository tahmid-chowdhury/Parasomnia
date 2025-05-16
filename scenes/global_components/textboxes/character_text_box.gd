extends CanvasLayer

@onready var Textbox_Container = get_node("Textbox_Container")
@onready var Start_Symbol = get_node("Textbox_Container/MarginContainer/HBoxContainer/Textbox_Start")
@onready var End_Symbol = get_node("Textbox_Container/MarginContainer/HBoxContainer/Textbox_End")
@onready var TextInput = get_node("Textbox_Container/MarginContainer/HBoxContainer/TextInput")


var TextTween
var current_state = State.READY
const Char_read_rate = 0.05
var text_queue = [
	
]

enum State {
	READY, 
	READING,
	FINISHED
}

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("enter"):
				TextInput.visible_ratio = 1.0
				if TextTween:
					TextTween.kill()
				End_Symbol.text = "v"
				change_text_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("enter"):
				if text_queue.is_empty():
					hide_textbox()
				change_text_state(State.READY)
				reset_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func _ready() -> void:
	if text_queue.is_empty():
		hide_textbox()
	
func reset_textbox():
	TextInput.text = ""
	Start_Symbol.text = ""
	End_Symbol.text = ""
	


func show_textbox():
	Textbox_Container.show()
	Start_Symbol.text = "*"
	
func hide_textbox():
	TextInput.text = ""
	Start_Symbol.text = ""
	End_Symbol.text = ""
	Textbox_Container.hide()
	
	
func display_text():
	var display_text  = text_queue.pop_front()
	TextInput.bbcode_enabled = true
	TextInput.text = display_text
	TextInput.visible_ratio = 0.0
	change_text_state(State.READING)
	show_textbox()
	TextInput.visible_ratio = 0.0
	TextTween = create_tween()
	TextTween.tween_property(TextInput, "visible_ratio", 1.0, len(display_text) * Char_read_rate)
	await TextTween.finished
	change_text_state(State.FINISHED)
	End_Symbol.text = "v"
	
func change_text_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass
		State.READING:
			pass
		State.FINISHED:
			pass
	
	
	
	
