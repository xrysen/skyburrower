extends CharacterBody2D

@export var speed: float = 100.0
@export var on_death: PackedScene
@export var coin_scene: PackedScene
var max_health: int = 5
var current_health: int
var fade_timer: Timer

var wiggle_amplitude = 50.0   # max vertical offset in pixels
var wiggle_frequency = 3.0    # how fast it wiggles 
var wiggle_timer = 0.0

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
	for i in range(12):
		var spore = on_death.instantiate()
		var angle = (TAU / 12) * i + randf_range(-0.2, 0.2)
		spore.global_position = global_position
		spore.direction = Vector2.RIGHT.rotated(angle)
		get_parent().add_child(spore)
	queue_free()

func _on_fade_timeout():
	$HealthBar.visible = false

func _process(delta):
	position.x -= speed * delta
	wiggle_timer += delta
	
	# Calculate vertical wiggle using sine wave
	var vertical_offset = sin(wiggle_timer * TAU * wiggle_frequency) * wiggle_amplitude
	
	# Apply wiggle to y position relative to starting y (or current)
	position.y += vertical_offset * delta
	
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
	
func initialize(config: Dictionary):
	if config.has("speed"):
		speed = config["speed"]
	if config.has("on_death"):
		on_death = config["on_death"]
	if config.has("coin_scene"):
		coin_scene = config["coin_scene"]
