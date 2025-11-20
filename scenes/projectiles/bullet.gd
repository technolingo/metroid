extends Area2D

var direction: Vector2
var speed: int = 400


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(0.8, 0.8), 0.1).from(Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func setup(pos: Vector2, dir: Vector2):
	position = pos + dir * 16
	direction = dir


func _on_body_entered(body: Node2D) -> void:
	if "receive_damage" in body:
		body.receive_damage()
	queue_free()
