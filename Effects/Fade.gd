extends CanvasLayer

@onready var fade_rect: ColorRect = $FadeRect

func fade_in(duration: float = 1.0) -> void:
	fade_rect.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func fade_out(duration: float = 1.0) -> void:
	fade_rect.modulate.a = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a",1.0,duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
