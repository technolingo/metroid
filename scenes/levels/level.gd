extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/projectiles/bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	#bullet.position = pos
	#bullet.direction = dir
	bullet.setup(pos, dir)
	$Projectiles.add_child(bullet)
