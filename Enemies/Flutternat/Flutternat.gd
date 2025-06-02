extends CharacterBody2D

@export var speed: float = 100.0
var max_health: int = 5
var current_health: int
var fade_timer: Timer

func _ready():
	$AnimatedSprite2D.play("default")
	$HealthBar.visible = false
	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	fade_timer = Timer.new()
	fade_timer.wait_time = 0.5
	fade_timer.one_shot = true
	fade_timer.connect("timeout", Callable(self, "_on_fade_timeout"))
	add_child(fade_timer)

func take_damage(amount: int):
	current_health -= amount
	modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	$HealthBar.value = current_health
	$HealthBar.visible = true
	fade_timer.start()

	if current_health <= 0:
		die()

func die():
	queue_free()

func _on_fade_timeout():
	$HealthBar.visible = false

func _process(delta):
	position.x -= speed * delta
	
var damage_cooldown = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if damage_cooldown:
		return
	if body.is_in_group("player"):
		body.take_damage(1) 
		damage_cooldown = true
		await get_tree().create_timer(1.0).timeout
		damage_cooldown = false
		
func flash_on_hit():
	modulate = Color(1, 0.5, 0.5) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1,1,1)
