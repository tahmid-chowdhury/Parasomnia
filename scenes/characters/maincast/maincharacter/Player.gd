class_name Player extends CharacterBody2D

var move_speed: float = 25.0
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var state: String = "idle"

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer 


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	velocity = direction * move_speed
	
	if Input.is_action_just_pressed("space"):
		for i in range(PartyManager.party_members.size()):
					TextBox.queue_text("Theres absolutely [color=red]NO[/color] way that just happened")
			
	if Input.is_action_pressed("shift"):
		move_speed = 50
	else:
		move_speed = 25

	var changed_state = SetState()
	var changed_dir = SetDirection()

	if state == "walk" or changed_state or changed_dir:
		UpdateAnimation()

func _physics_process(delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	var new_dir: Vector2 = cardinal_direction

	if direction == Vector2.ZERO:
		return false

	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	var original_scale = sprite.scale
	original_scale.x = -abs(original_scale.x) if cardinal_direction == Vector2.LEFT else abs(original_scale.x)
	sprite.scale = original_scale

	return true

func SetState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true

func UpdateAnimation() -> void:
	if animation_player == null:
		print("Error: AnimationPlayer node not found!")
		return

	var anim_name = state + "_" + AnimDirection()

	if animation_player.current_animation != anim_name or state == "walk":
		animation_player.play(anim_name)

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
