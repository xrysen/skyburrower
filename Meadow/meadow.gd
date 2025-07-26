extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var fire_rate := Global.fire_rate
@export var strength := Global.strength
var fire_timer := 0.0
var maxHealth := Global.max_health
var current_health := Global.max_health
var magnet := Global.magnet

var follow_speed := 5.0
var offset = Vector2(20, 15)

var is_dying := false
signal player_died


func _ready():
	$AnimatedSprite2D.play("default")
	
	$SmokeTrail.visible = false
	$SmokeTrail.emitting = false
	$FireTrail.visible = false
	$FireTrail.emitting = false

	
func _process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		fire_bullet()
		fire_timer = fire_rate
		
	var mouse_pos = get_global_mouse_position()
	var screen_size = get_viewport_rect().size
	
	var clamped_x = clamp(mouse_pos.x, 0, screen_size.x)
	var clamped_y = clamp(mouse_pos.y, 0, screen_size.y)
	
	if is_dying:
		move_offscreen(delta)
	else:
		global_position = global_position.lerp(Vector2(clamped_x, clamped_y), follow_speed * delta)

var death_speed = Vector2(100, 100) 

func move_offscreen(delta):
	global_position += death_speed * delta

	var viewport = get_viewport_rect()
	if global_position.y > viewport.size.y + 100 or global_position.x > viewport.size.x + 100:
		on_death_effect_done()

func fire_bullet():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.damage = strength
	
	bullet.global_position = global_position + offset

signal health_changed

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed")
	flash_on_hit()
	
	if current_health == 0:
		play_death_effect()
	
func play_death_effect():
	var tween := get_tree().create_tween()
	is_dying = true
	# Show and start the smoke/fire trails
	$SmokeTrail.visible = true
	$SmokeTrail.emitting = true
	$FireTrail.visible = true
	$FireTrail.emitting = true

	# Stop player animation
	if $AnimatedSprite2D:
		$AnimatedSprite2D.stop()

	var viewport = get_viewport_rect()
	var target_pos = position

	# Move down past bottom of screen plus some margin
	target_pos.y = viewport.size.y + 100
	# Move right some amount (adjust as needed)
	target_pos.x += 200

	# Tween to that position over 3 seconds (adjust speed/duration)
	tween.tween_property(self, "position", target_pos, 4.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(2.0).timeout
	emit_signal("player_died")

func on_death_effect_done():
	emit_signal("player_died")
	

func flash_on_hit(times: int = 6, interval: float = 0.1) -> void:
	for i in range(times):
		visible = false
		await get_tree().create_timer(interval).timeout
		visible = true
		await get_tree().create_timer(interval).timeout


	
	
	
