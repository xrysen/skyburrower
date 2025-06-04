extends Area2D

var speed: float = 100.0
var player: CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("default")
	connect("body_entered", Callable(self, "_on_body_entered"))
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
func _process(delta):
	if not is_instance_valid(player):
		return
	
	if "magnet" in player:
		var distance = player.global_position.distance_to(global_position)
		var attraction_range = player.magnet

		if distance < attraction_range:
			var pull_strength = clamp(1.0 - (distance / attraction_range), 0.0, 1.0)
			var direction = (player.global_position - global_position).normalized()
			var magnet_speed = speed * 1.5 * pull_strength
			position += direction * magnet_speed * delta
	position.x -= speed * delta

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		# Play noise
		# increase total coins
		queue_free()
