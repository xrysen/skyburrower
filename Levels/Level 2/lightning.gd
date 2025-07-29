extends Parallax2D

@onready var cloud_sprite := $Sprite2D


func _ready():
	spawn_lightning_loop()


func spawn_lightning_loop() -> void:
	while true:
		await get_tree().create_timer(randf_range(4.0, 12.0)).timeout

		flash_lightning()


func flash_lightning():
	var flash_count = randi_range(2, 3)  # 2 or 3 flashes randomly

	for i in flash_count:
		# Brighten instantly
		cloud_sprite.modulate = Color(1.6, 1.6, 1.6, 1.0)

		# Fade back quickly (0.1s)
		var tween = get_tree().create_tween()
		(
			tween
			. tween_property(cloud_sprite, "modulate", Color(1, 1, 1, 1), 0.1)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_OUT)
		)

		# Wait a short random interval before next flash
		var wait_time = randf_range(0.05, 0.25)
		await get_tree().create_timer(wait_time).timeout
