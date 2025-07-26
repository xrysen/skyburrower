extends Area2D

var speed: float = 100.0
var player: CharacterBody2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _process(delta):
	position.x -= speed * delta
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
	# Play noise
	#Global.add_coins(1)
		queue_free()
