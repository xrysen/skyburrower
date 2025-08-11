extends Node  # or Node2D or Control

@export var level_duration: float = 30.0
@export var end_delay: float = 1.5
@export var levelNumber: int
@export var stageNumber: int
signal level_ended
@onready var ui = $Ui

var fade := preload("res://Effects/fade.tscn").instantiate()
var big_coin_scene := preload("res://Items/Coins/BigCoin/BigCoin.tscn")
var small_coin_scene := preload("res://Items/Coins/SmallCoin/SmallCoin.tscn")
var carrot_scene := preload("res://Items/Carrot/carrot.tscn")
@export var coin_spawn_interval_range: Vector2 = Vector2(1.5, 4.0)

var spawning_coins = true
var carrot_interval = level_duration / 5
var current_carrots := 0
const MAX_CARROTS := 5


func _ready():
	var player = get_node("Meadow")
	player.player_died.connect(_on_player_died)

	start_level_timer()
	add_child(fade)
	spawn_coins_loop()
	spawn_carrots_loop()
	fade.fade_in()


func connect_carrots():
	for carrot in get_tree().get_nodes_in_group("Carrot"):
		carrot.carrot_collected.connect(on_carrot_collected)


func on_carrot_collected():
	current_carrots += 1
	ui.set_carrot_count(current_carrots)


func start_level_timer() -> void:
	await create_timer(level_duration).timeout
	await create_timer(end_delay).timeout
	end_level(true)


func create_timer(time: float) -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	timer.start()
	return timer


func _on_player_died():
	current_carrots = 0
	end_level(false)


func end_level(win: bool):
	await fade.fade_out(1.5)
	fade.hide()
	get_tree().paused = true
	spawning_coins = false
	$Ui.hide()
	emit_signal("level_ended")
	if !win:
		var defeat_scene = preload("res://UI/Scenes/defeat.tscn").instantiate()
		add_child(defeat_scene)
	else:
		Global.complete_level(levelNumber, current_carrots)
		var victory_scene = preload("res://UI/Scenes/victory.tscn").instantiate()
		victory_scene.set_carrot_count(current_carrots)
		add_child(victory_scene)


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


func spawn_carrots_loop() -> void:
	var num_carrots := 5
	var interval := (level_duration / num_carrots) - 1

	for i in num_carrots:
		await get_tree().create_timer(interval).timeout
		spawn_carrot(levelNumber, stageNumber)


func spawn_carrot(level_num: int, stage_num: int):
	var screen_rect = get_viewport().get_visible_rect()
	var screen_top = screen_rect.position.y
	var screen_bottom = screen_rect.position.y + screen_rect.size.y
	var screen_right = screen_rect.position.x + screen_rect.size.x

	var y = randf_range(screen_top + 30, screen_bottom - 30)
	var x = screen_right + randf_range(30, 80)

	var spawn_pos = Vector2(x, y)

	var carrot = carrot_scene.instantiate()
	carrot.levelNumber = level_num
	carrot.stageNumber = stage_num
	carrot.global_position = spawn_pos
	add_child(carrot)
	carrot.carrot_collected.connect(on_carrot_collected)
