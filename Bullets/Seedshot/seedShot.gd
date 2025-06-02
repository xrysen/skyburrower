extends Area2D

@export var speed := 500.0
@export var direction := Vector2.RIGHT
var damage := 1


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position += direction.normalized() * speed * delta
	
	if position.x < -100 or position.y > get_viewport_rect().size.x + 100:
		queue_free()
		
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
