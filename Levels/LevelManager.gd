extends Node  # or Node2D or Control

@export var level_duration: float = 30.0
@export var end_delay: float = 1.5
signal level_ended

var fade := preload("res://Effects/fade.tscn").instantiate()
var big_coin_scene := preload("res://Items/Coins/BigCoin/BigCoin.tscn")
var small_coin_scene := preload("res://Items/Coins/SmallCoin/SmallCoin.tscn")
@export var coin_spawn_interval_range: Vector2 = Vector2(1.5, 4.0)

var spawning_coins = true

func _ready():
	var player = get_node("Meadow")
	player.player_died.connect(_on_player_died)
	
	start_level_timer()
	add_child(fade)
	spawn_coins_loop()
	fade.fade_in()

func start_level_timer() -> void:
	await create_timer(level_duration).timeout
	await create_timer(end_delay).timeout
	end_level()

func create_timer(time: float) -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	timer.start()
	return timer

func _on_player_died():
	end_level()

func end_level():
	await fade.fade_out(1.5)
	spawning_coins = false
	emit_signal("level_ended")
	get_tree().change_scene_to_file("res://WorldMap/worldMap.tscn")
	
func spawn_coins_loop() -> void:
	while spawning_coins:
		var interval = randf_range(coin_spawn_interval_range.x, coin_spawn_interval_range.y)
		await get_tree().create_timer(interval).timeout
		
		spawn_random_coins()

func spawn_random_coins():
	var raw_luck = clamp(Global.luck, 1.0, 10.0)
	var luck = (raw_luck - 1.0) / 9.0  # normalize to 0.0–1.0

	# Scale base coin count: 2–7 coins at min luck to high luck
	var min_coins = int(lerp(2, 10, luck)) 
	var max_coins = int(lerp(4, 20, luck))

	var coin_count = randi_range(min_coins, max_coins)

	var screen_rect = get_viewport().get_visible_rect()
	var screen_top = screen_rect.position.y
	var screen_bottom = screen_rect.position.y + screen_rect.size.y
	var screen_right = screen_rect.position.x + screen_rect.size.x

	for i in coin_count:
		var y = randf_range(screen_top + 30, screen_bottom - 30) + randf_range(-10, 10)
		var x = screen_right + randf_range(30, 80)

		var spawn_pos = Vector2(x, y)

		var is_big = randf() < pow(luck, 1.2) * 0.6  # chance of big coin increases with luck
		var coin_scene = big_coin_scene if is_big else small_coin_scene
		var coin = coin_scene.instantiate()
		coin.global_position = spawn_pos
		add_child(coin)

		
