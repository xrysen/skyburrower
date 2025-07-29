extends Area2D

@export var levelNumber: int
@export var stageNumber: int
var speed: float = 100.0
var player: CharacterBody2D
signal carrot_collected


func _ready():
	add_to_group("Carrot")
	connect("body_entered", Callable(self, "_on_body_entered"))
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _process(delta):
	position.x -= speed * delta


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		emit_signal("carrot_collected")
		queue_free()
