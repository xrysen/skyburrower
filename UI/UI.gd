extends Control

@export var heart_scene: PackedScene
@export var player_path: NodePath
@onready var heart_container = $GridContainer 
@onready var coin_label = $CoinLabel

var player

func _ready():
	player = get_node(player_path)
	player.health_changed.connect(update_hearts)
	update_hearts()
	Global.connect("coins_changed", Callable(self, "update_coin_display"))
	update_coin_display()
	
func update_coin_display():
	coin_label.text = str(Global.coin_count)
	
func update_hearts():
	for child in heart_container.get_children():
		child.queue_free()
	
	for i in range(player.current_health):
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
