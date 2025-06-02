extends Control

@export var heart_scene: PackedScene
@export var player_path: NodePath
@onready var heart_container = $HBoxContainer 

var player

func _ready():
	player = get_node(player_path)
	print("Player is", player)
	player.health_changed.connect(update_hearts)
	update_hearts()
	
func update_hearts():
	for child in heart_container.get_children():
		child.queue_free()
	
	for i in range(player.current_health):
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
