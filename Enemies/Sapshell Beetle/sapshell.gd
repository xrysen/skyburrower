extends CharacterBody2D

@export var speed: float = 100.0
@export var coin_scene: PackedScene
var max_health: int = 5
var current_health: int
var fade_timer: Timer

var bob_timer := 0.0
var bob_interval := 2.5
var bob_distance := 6.0

var vertical_bounds = {"top": 0.0, "bottom": 0.0}
var vertical_direction := 1


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
	if coin_scene:
		var coin = coin_scene.instantiate()
		coin.global_position = global_position
		get_parent().add_child(coin)
	queue_free()


func _on_fade_timeout():
	$HealthBar.visible = false


func _process(delta):
	# Move left
	position.x -= speed * delta

	# Move vertically within bounds
	var vertical_speed_factor = 0.4
	position.y += speed * vertical_speed_factor * delta * vertical_direction

	var padding = 4.0

	if position.y <= vertical_bounds.top + padding:
		position.y = vertical_bounds.top + padding
		vertical_direction = 1  # Move down
	elif position.y >= vertical_bounds.bottom - padding:
		position.y = vertical_bounds.bottom - padding
		vertical_direction = -1  # Move up

	# Optional bobbing
	bob_timer += delta
	if bob_timer >= bob_interval:
		bob_timer = 0.0
		random_bob()


func random_bob():
	var offset = randf_range(-bob_distance, bob_distance)
	var tween = create_tween()
	(
		tween
		. tween_property(self, "position:y", position.y + offset, 0.3)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN_OUT)
	)


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
	modulate = Color(1, 1, 1)


func initialize(config: Dictionary):
	if config.has("speed"):
		speed = config["speed"]
	if config.has("coin_scene"):
		coin_scene = config["coin_scene"]
	if config.has("vertical_bounds"):
		vertical_bounds = config["vertical_bounds"]
