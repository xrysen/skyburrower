extends Node2D

var carrot_count := 0
@onready var carrot_container = $TextureRect/CarrotContainer
var empty_carrot := preload("res://UI/Scenes/emptyCarrot.tscn")
var full_carrot := preload("res://UI/Scenes/carrotUI.tscn")
const MAX_CARROTS = 5


func _ready():
	$TextureRect/Coins.text = str(Global.coin_count)
	display_carrots()


func _physics_process(_delta: float) -> void:
	$TextureRect/Coins.text = str(Global.coin_count)


func _on_cont_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://WorldMap/worldMap.tscn")


func set_carrot_count(count: int) -> void:
	carrot_count = count


func display_carrots():
	for child in carrot_container.get_children():
		child.queue_free()

	for i in range(MAX_CARROTS):
		carrot_container.add_child(empty_carrot.instantiate())

	fill_carrots()


func fill_carrots():
	await get_tree().create_timer(0.2).timeout

	for i in range(carrot_count):
		await get_tree().create_timer(0.2).timeout
		var old_carrot = carrot_container.get_child(i)

		old_carrot.queue_free()
		var full = full_carrot.instantiate()
		carrot_container.add_child(full)
		carrot_container.move_child(full, i)
