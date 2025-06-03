extends Node2D

@onready var visual_root = $VisualRoot
@export var spawn_delay: float = 3.0

func _ready():
	visual_root.position.y = 64  # Start underground
	spawn_after_delay()

func spawn_after_delay():
	await get_tree().create_timer(spawn_delay).timeout
	grow_in()

func grow_in():
	var tween = create_tween()
	tween.tween_property(visual_root, "position:y", 0.0, 0.6) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
