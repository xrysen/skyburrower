extends Control

@export var heart_scene: PackedScene
@export var player_path: NodePath
@export var levelNumber: int
@export var stageNumber: int
@onready var heart_container = $GridContainer
@onready var coin_label = $CoinLabel
@onready var carrot_container = $CarrotContainer

var player
var empty_carrot := preload("res://UI/emptyCarrot.tscn")
var full_carrot := preload("res://UI/carrotUI.tscn")

var current_carrots := 0
const MAX_CARROTS := 5


func _ready():
	player = get_node(player_path)
	player.health_changed.connect(update_hearts)
	update_hearts()
	Global.connect("coins_changed", Callable(self, "update_coin_display"))
	update_carrot_display()
	update_coin_display()


func update_coin_display():
	coin_label.text = str(Global.coin_count)


func update_carrot_display():
	for child in carrot_container.get_children():
		child.queue_free()

	for i in range(MAX_CARROTS):
		var scene = full_carrot if i < current_carrots else empty_carrot
		carrot_container.add_child(scene.instantiate())


func set_carrot_count(value: int):
	current_carrots = clamp(value, 0, MAX_CARROTS)
	update_carrot_display()


func update_hearts():
	for child in heart_container.get_children():
		child.queue_free()

	for i in range(player.current_health):
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
