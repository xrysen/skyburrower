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


func _ready():
	$AnimatedSprite2D.play("default")
	
func _process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		fire_bullet()
		fire_timer = fire_rate
		
	var mouse_pos = get_global_mouse_position()
	var screen_size = get_viewport_rect().size
	
	var clamped_x = clamp(mouse_pos.x, 0, screen_size.x)
	var clamped_y = clamp(mouse_pos.y, 0, screen_size.y)
	
	global_position = global_position.lerp(Vector2(clamped_x, clamped_y), follow_speed * delta)
	
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
	
func flash_on_hit(times: int = 6, interval: float = 0.1) -> void:
	for i in range(times):
		visible = false
		await get_tree().create_timer(interval).timeout
		visible = true
		await get_tree().create_timer(interval).timeout


	
	
	
