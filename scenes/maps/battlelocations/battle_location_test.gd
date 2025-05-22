extends Control

var battle_enemies: Array = []
var selected_enemy_index: int = 0

@onready var attack_button   := $CanvasLayer/Control/Panel/VBoxContainer/Row1/HBoxContainer/AttackButton
@onready var selector        := $CanvasLayer/EnemySelector
@onready var name_label      := $CanvasLayer/HBoxContainer/Panel2/VBoxContainer/NameLabel    as RichTextLabel
@onready var level_label     := $CanvasLayer/HBoxContainer/Panel2/VBoxContainer/LevelLabel   as RichTextLabel
@onready var selector_offset := Vector2(20, 0)
var selector_float: float    = 0.0

func _ready() -> void:
	EnemyManager.place_enemies()
	PartyManager.place_party_members()
	_refresh_enemy_list()
	attack_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_bumper"):
		_change_selection(-1)
	elif event.is_action_pressed("right_bumper"):
		_change_selection(+1)

func _process(delta: float) -> void:
	if selector.visible:
		selector_float = sin(Time.get_ticks_msec() / 200.0) * 5
		_update_selector_position()

func refresh_after_enemy_removed() -> void:
	print(">>> refresh_after_enemy_removed() called")
	await get_tree().process_frame 
	_refresh_enemy_list()


func _change_selection(dir: int) -> void:
	if battle_enemies.is_empty():
		return
	selected_enemy_index = (selected_enemy_index + dir) % battle_enemies.size()
	_refresh_enemy_list()

func _refresh_enemy_list() -> void:
	battle_enemies = get_tree().get_nodes_in_group("battle_enemies")
	battle_enemies = battle_enemies.filter(func(e):
		return is_instance_valid(e)
	)

	print("--- Enemies Remaining:", battle_enemies.size())

	if battle_enemies.is_empty():
		print("No enemies left — hiding selector")
		selected_enemy_index = 0
		selector.visible = false
		_clear_info()
		return
	var old_index = selected_enemy_index
	selected_enemy_index = clamp(selected_enemy_index, 0, battle_enemies.size() - 1)
	if old_index != selected_enemy_index:
		print("Selected index adjusted from", old_index, "to", selected_enemy_index)

	_highlight_and_position()
	$CanvasLayer/Control.selected_enemy_index = selected_enemy_index
	_update_enemy_info()

func _highlight_and_position() -> void:
	for i in range(battle_enemies.size()):
		var e = battle_enemies[i]
		e.modulate = Color(1, 0.6, 0.6) if i == selected_enemy_index else Color(1, 1, 1)

	selector.visible = true
	_update_selector_position()

func _update_selector_position() -> void:
	var t = battle_enemies[selected_enemy_index]
	if is_instance_valid(t):
		selector.global_position = t.global_position + selector_offset + Vector2(0, selector_float)

func _update_enemy_info() -> void:
	var node = battle_enemies[selected_enemy_index]
	var name = node.get_meta("enemy_name")
	var lvl  = node.get_meta("enemy_level")

	name_label.bbcode_text  = "[b]Name:[/b]  %s" % name
	level_label.bbcode_text = "[b]Level:[/b] %s" % lvl

func _clear_info() -> void:
	name_label.clear()
	level_label.clear()
