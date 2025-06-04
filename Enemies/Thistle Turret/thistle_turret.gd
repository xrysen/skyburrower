extends Node2D

@onready var visual_root = $VisualRoot
@export var spawn_delay: float = 3.0
@onready var turret_sprite = $VisualRoot/AnimatedSprite2D
@onready var dust = get_node("DustBurst")

@export var player_path: NodePath
@export var coin_scene: PackedScene
@onready var player = get_node(player_path)

# Pod
@export var pod_scene: PackedScene
@export var shoot_interval: float = 2.0
@export var pod_speed: float = 400.0

var current_direction := ""
var shoot_timer := 0.0

var max_health: int = 5
var current_health: int
var fade_timer: Timer

func _ready():
	visual_root.position.y = 64  # Start underground
	spawn_after_delay()
	set_process(false)
	$HealthBar.visible = false
	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	fade_timer = Timer.new()
	fade_timer.wait_time = 0.5
	fade_timer.one_shot = true
	fade_timer.connect("timeout", Callable(self, "_on_fade_timeout"))
	add_child(fade_timer)
	

func spawn_after_delay():
	await get_tree().create_timer(spawn_delay).timeout
	grow_in()
	start_tracking()

func grow_in():
	play_dust()
	var tween = create_tween()
	tween.tween_property(visual_root, "position:y", 0.0, 0.6) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	
	
func play_dust():
	dust.restart()
	
func start_tracking():
	set_process(true)
	shoot_timer = shoot_interval
	
func _process(_delta):
	update_facing_direction()
	shoot_timer -=_delta
	if shoot_timer <= 0.0:
		shoot_timer = shoot_interval
		shoot_pod()
	
func update_facing_direction():
	if not is_instance_valid(player):
		return
		
	var to_player = player.global_position - global_position
	var x = to_player.x
	var y = to_player.y
	
	var new_direction = ''
	
	if y < -20:
		if x < -20:
			new_direction = "up_left"
		elif x > 20:
			new_direction = "up_right"
		else:
			new_direction = "up_left"
	else:
		new_direction = "left" if x < 0 else "right"
	
	if new_direction != current_direction:
		current_direction = new_direction
		turret_sprite.play(current_direction)
		
func shoot_pod():
	if not is_instance_valid(player):
		return
	if pod_scene == null:
		print("No bullet scene")
		return
	
	var pod = pod_scene.instantiate()
	get_parent().add_child(pod)
	
	pod.global_position = global_position
	var direction = (player.global_position - global_position).normalized()
	
	if pod.has_method("set_velocity"):
		pod.set_velocity(direction * pod_speed)
	else:
		pod.velocity = direction * pod_speed
		

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
	
func flash_on_hit():
	modulate = Color(1, 0.5, 0.5) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1,1,1)
