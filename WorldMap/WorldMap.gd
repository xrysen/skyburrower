extends Node2D

var fade := preload("res://Effects/fade.tscn").instantiate()
const MAX_UPGRADE := 7
var empty_upgrade := preload("res://WorldMap/upgradeEmpty.tscn")
var full_upgrade := preload("res://WorldMap/upgradeFull.tscn")

@onready var heart_container = $HeartContainer
@onready var bstr_container = $BulletStrengthContainer
@onready var bspd_container = $BulletSpeedContainer
@onready var bullets_container = $BulletsContainer
@onready var speed_container = $SpeedContainer
@onready var magnet_container = $MagnetContainer
@onready var luck_container = $LuckContainer


func _ready():
	$Label.text = "%d" % Global.coin_count
	add_child(fade)
	draw_upgrades()

	fade.fade_in()


func draw_heart_upgrade():
	for child in heart_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var heart_icon = full_upgrade if i < Global.upgrades.health else empty_upgrade
		heart_container.add_child(heart_icon.instantiate())


func draw_bullet_strength():
	for child in bstr_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var bs_icon = full_upgrade if i < Global.upgrades.strength else empty_upgrade
		bstr_container.add_child(bs_icon.instantiate())


func draw_bullet_speed():
	for child in bspd_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var bspd_icon = full_upgrade if i < Global.upgrades.fire_rate else empty_upgrade
		bspd_container.add_child(bspd_icon.instantiate())


func draw_bullet_total():
	for child in bullets_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var bull_icon = full_upgrade if i < Global.upgrades.num_bullets else empty_upgrade
		bullets_container.add_child(bull_icon.instantiate())


func draw_speed():
	for child in speed_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var spd_icon = full_upgrade if i < Global.upgrades.speed else empty_upgrade
		speed_container.add_child(spd_icon.instantiate())


func draw_magnet():
	for child in magnet_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var mag_icon = full_upgrade if i < Global.upgrades.magnet else empty_upgrade
		magnet_container.add_child(mag_icon.instantiate())


func draw_luck():
	for child in luck_container.get_children():
		child.queue_free()

	for i in range(MAX_UPGRADE):
		var luck_icon = full_upgrade if i < Global.upgrades.luck else empty_upgrade
		luck_container.add_child(luck_icon.instantiate())


func draw_upgrades():
	draw_luck()
	draw_magnet()
	draw_speed()
	draw_bullet_total()
	draw_bullet_speed()
	draw_bullet_strength()
	draw_heart_upgrade()


func handle_upgrade(upgrade):
	if Global.upgrades[upgrade] < 7:
		Global.upgrades[upgrade] += 1
		Global.apply_upgrades()
		draw_upgrades()


func _on_luck_button_pressed() -> void:
	handle_upgrade("luck")


func _on_magnet_button_pressed() -> void:
	handle_upgrade("magnet")


func _on_speed_button_pressed() -> void:
	handle_upgrade("speed")


func _on_num_bullets_button_pressed() -> void:
	handle_upgrade("num_bullets")


func _on_bspd_button_pressed() -> void:
	handle_upgrade("fire_rate")


func _on_bs_button_pressed() -> void:
	handle_upgrade("strength")


func _on_h_button_pressed() -> void:
	handle_upgrade("health")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 1/level1-1.tscn")
