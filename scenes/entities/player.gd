extends CharacterBody2D


var direction_x: float
const SPEED = 300.0
@export var jump_velocity = -300.0
@export var gravity = 1000
signal shoot(pos: Vector2, dir: Vector2)


func handle_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):  # and is_on_floor()
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("shoot") and not $ReloadTimer.time_left:
		shoot.emit(position, get_local_mouse_position().normalized())
		$ReloadTimer.start()


func _physics_process(delta: float) -> void:
	handle_input()
	velocity.x = direction_x * SPEED
	apply_gravity(delta)
	animate()
	move_and_slide()


func apply_gravity(delta):
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	velocity.y += gravity * delta


func animate():
	$Legs.flip_h = direction_x < 0
	$AnimationPlayer.current_animation = "run" if direction_x else "idle"
