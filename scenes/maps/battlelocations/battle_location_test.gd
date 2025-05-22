extends Control

var battle_enemies: Array = []
var selected_enemy_index: int = 0

@onready var attack_button := $CanvasLayer/Control/Panel/VBoxContainer/Row1/HBoxContainer/AttackButton
@onready var selector: Node2D     = $CanvasLayer/EnemySelector
@onready var selector_offset      = Vector2(20, 0)
var selector_float: float         = 0.0

func _ready() -> void:
	EnemyManager.place_enemies()
	PartyManager.place_party_members()
	battle_enemies = get_tree().get_nodes_in_group("battle_enemies")
	attack_button.grab_focus()

	if battle_enemies.size() > 0:
		selected_enemy_index = 0
		highlight_selected_enemy()
	else:
		selector.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_bumper"):
		select_previous_enemy()
	elif event.is_action_pressed("right_bumper"):
		select_next_enemy()

func select_previous_enemy() -> void:
	if battle_enemies.is_empty(): return
	selected_enemy_index = (selected_enemy_index - 1 + battle_enemies.size()) % battle_enemies.size()
	highlight_selected_enemy()

func select_next_enemy() -> void:
	if battle_enemies.is_empty(): return
	selected_enemy_index = (selected_enemy_index + 1) % battle_enemies.size()
	highlight_selected_enemy()

func _process(delta: float) -> void:
	if selector.visible:
		selector_float = sin(Time.get_ticks_msec() / 200.0) * 5
		update_selector_position()

func update_selector_position() -> void:
	if selected_enemy_index < battle_enemies.size():
		var t = battle_enemies[selected_enemy_index]
		if is_instance_valid(t):
			selector.global_position = t.global_position + selector_offset + Vector2(0, selector_float)

func highlight_selected_enemy() -> void:
	battle_enemies = battle_enemies.filter(func(e):
		return is_instance_valid(e)
	)

	if battle_enemies.is_empty():
		selected_enemy_index = 0
		selector.visible = false
		return

	selected_enemy_index = clamp(selected_enemy_index, 0, battle_enemies.size() - 1)
	$CanvasLayer/Control.selected_enemy_index = selected_enemy_index

	for i in range(battle_enemies.size()):
		var e = battle_enemies[i]
		e.modulate = Color(1, 0.6, 0.6) if i == selected_enemy_index else Color(1, 1, 1)


	selector.visible = true
	update_selector_position()

func refresh_after_enemy_removed() -> void:
	await get_tree().process_frame

	battle_enemies = get_tree().get_nodes_in_group("battle_enemies")
	battle_enemies = battle_enemies.filter(func(e):
		return is_instance_valid(e)
	)

	if battle_enemies.is_empty():
		selected_enemy_index = 0
		selector.visible = false
		return

	selected_enemy_index = clamp(selected_enemy_index, 0, battle_enemies.size() - 1)
	highlight_selected_enemy()
