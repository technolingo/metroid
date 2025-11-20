extends CharacterBody2D


var speed: int = 40
var direction: Vector2
var health: int = 3
var player: CharacterBody2D


func _physics_process(_delta: float) -> void:
	if player:
		# get the direction towards the player by subtracting the player position by the drone position
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()


func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body


func _on_detection_area_body_exited(_body: CharacterBody2D) -> void:
	player = null


func explode():
	speed = 0
	$AnimatedSprite2D.hide()
	$Explosion.show()
	$Explosion/ExplosionAnimation.play("explosion")
	await $Explosion/ExplosionAnimation.animation_finished
	queue_free()  # deletes the drone after explosion
	#for d in get_tree().get_nodes_in_group("drones"):
		#if position.distance_to(d.position) <= 50:
			#d.explode()


func chain_reaction():
	# called by godot mid animation
	for d in get_tree().get_nodes_in_group("drones"):
		if position.distance_to(d.position) <= 50:
			d.explode()


func _on_explosion_area_body_entered(_body: CharacterBody2D) -> void:
	explode()


func receive_damage():
	if health > 1:
		health -= 1
	else:
		explode()
