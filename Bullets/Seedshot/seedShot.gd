extends Area2D

@export var speed := 500.0
@export var direction := Vector2.RIGHT
var damage := 1


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("area_entered", Callable(self, "_on_area_entered"))


func _process(delta):
	position += direction.normalized() * speed * delta

	if position.x < -100 or position.y > get_viewport_rect().size.x + 100:
		queue_free()


func _on_body_entered(body):
	var target = get_damageable_target(body)
	if target:
		target.take_damage(damage)
		queue_free()


func _on_area_entered(area):
	var target = get_damageable_target(area)
	if target:
		target.take_damage(damage)
		queue_free()


func get_damageable_target(node):
	if node.is_in_group("enemies") and node.has_method("take_damage"):
		return node
	var parent = node.get_parent()
	if parent and parent.is_in_group("enemies") and parent.has_method("take_damage"):
		return parent
	return null
