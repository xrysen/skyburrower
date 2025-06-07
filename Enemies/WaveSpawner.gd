extends Node

@export var enemy_scene: PackedScene
@export var on_death: PackedScene
@export var coin_scene: PackedScene
@export var enemies_per_wave: int = 5
@export var time_between_spawns: float = 0.5
@export var time_between_waves: float = 3.0
@export var enemy_speed: float = 100.0
@export var max_waves: int = 5

var current_wave = 0
var enemies_spawned = 0

func _ready():
	start_wave()
	
func start_wave():
	enemies_spawned = 0
	current_wave +=1
	spawn_enemies()
	
func spawn_enemies():
	if enemies_spawned < enemies_per_wave and current_wave <= max_waves:
		spawn_enemy()
		enemies_spawned += 1
		await get_tree().create_timer(time_between_spawns).timeout
		spawn_enemies()
	else:
		await get_tree().create_timer(time_between_waves).timeout
		start_wave()

var last_spawn_y = -100  # Keep track of last y position
var min_distance_y = 80  # Minimum vertical distance between spawns

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size

	# Random vertical position with spacing check
	var y : float
	var attempts = 0
	while true:
		y = randf_range(50, screen_size.y - 50)
		if abs(y - last_spawn_y) >= min_distance_y or attempts > 5:
			break
		attempts += 1
	
	last_spawn_y = y  # Store for next spawn
	var x = screen_size.x + 50  # Always just off the right side
	enemy.global_position = Vector2(x, y)

	# Define vertical movement bounds (just within screen)
	var vertical_bounds = {
		"top": 50.0,
		"bottom": screen_size.y - 50.0
	}
	
	# Generic config
	var config = {
		"speed": enemy_speed,
		"on_death": on_death,
		"coin_scene": coin_scene,
		"vertical_bounds": vertical_bounds
	}
	
	if "initialize" in enemy:
		enemy.initialize(config)

	get_parent().call_deferred("add_child", enemy)
	
	
