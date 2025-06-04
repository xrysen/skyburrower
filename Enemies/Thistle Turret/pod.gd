extends Area2D

@export var speed := 500.0
var velocity: Vector2 = Vector2.ZERO
var damage := 1


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position += velocity * delta
	
	if position.x < -100 or position.y > get_viewport_rect().size.x + 100:
		queue_free()
		
func set_velocity(v: Vector2) -> void:
	velocity = v.normalized() * speed
		
var damage_cooldown = false
func _on_body_entered(body: Node2D) -> void:
	if damage_cooldown:
		return
	if body.is_in_group("player"):
		queue_free()
		body.take_damage(1) 
		damage_cooldown = true
		await get_tree().create_timer(1.0).timeout
		damage_cooldown = false
