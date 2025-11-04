extends CharacterBody2D


var direction_x: float
const SPEED = 300.0
@export var jump_velocity = -300.0
@export var gravity = 1000
signal shoot(pos: Vector2, dir: Vector2)
const GUN_DIRECTIONS = {
	Vector2i(1, 0):   0,
	Vector2i(1, 1):   1,
	Vector2i(0, 1):   2,
	Vector2i(-1, 1):  3,
	Vector2i(-1, 0):  4,
	Vector2i(-1, -1): 5,
	Vector2i(0, -1):  6,
	Vector2i(1, -1):  7,
}


func handle_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("shoot") and not $ReloadTimer.time_left:
		handle_shoot()


func _physics_process(delta: float) -> void:
	handle_input()
	velocity.x = direction_x * SPEED
	apply_gravity(delta)
	animate()
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		#velocity += get_gravity() * delta
		velocity.y += gravity * delta


func handle_shoot():
	shoot.emit(position, get_local_mouse_position().normalized())
	$ReloadTimer.start()
	var tween = get_tree().create_tween()
	tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.2)
	tween.tween_property($Marker, "scale", Vector2(0.3, 0.3), 0.4)


func animate():
	# animate the legs
	$Legs.flip_h = direction_x < 0
	var animation := "idle"
	if direction_x and is_on_floor():
		animation = "run"
	elif not is_on_floor():
		animation = "jump"
	$LegsAnimation.current_animation = animation
	# handling torso directions
	var raw_dir = get_local_mouse_position().normalized()
	var adjusted_dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Torso.frame = GUN_DIRECTIONS[adjusted_dir]
	# place crosshairs
	$Marker.position = get_local_mouse_position().normalized() * 40
