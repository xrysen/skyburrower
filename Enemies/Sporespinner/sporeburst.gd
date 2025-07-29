extends Area2D

@export var speed := 100
var direction = Vector2.ZERO


func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()


func _process(delta):
	position += direction * speed * delta


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
