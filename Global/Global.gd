extends Node

var coin_count: int = 0
var fire_rate: float = 0.5
var strength: int = 1
var max_health: int = 3
var magnet: float = 25.0
var luck: int = 1
var speed: float = 3.0

var upgrades = {
	"health": 0, "strength": 0, "fire_rate": 0, "magnet": 0, "luck": 0, "num_bullets": 0, "speed": 0
}


func apply_upgrades():
	max_health = 3 + upgrades["health"]
	strength = 1 + upgrades["strength"]
	fire_rate = 0.5 - (upgrades["fire_rate"] * 0.05)
	magnet = 25.0 + (upgrades["magnet"] * 10.0)
	luck = 1 + (upgrades["luck"])
	speed = 3.0 + (upgrades["speed"] * 1.5)


var levels = [{"level": [{"carrot_count": 0, "completed": false}]}]

signal coins_changed
signal carrot_changed


func add_coins(amount: int = 1):
	coin_count += amount
	emit_signal("coins_changed")


func add_carrot(level, stage):
	levels[level - 1]["level"][stage - 1]["carrot_count"] += 1
	emit_signal("carrot_changed")


func reset_carrot(level, stage):
	levels[level - 1]["level"][stage - 1]["carrot_count"] = 0


func mark_stage_complete(level, stage):
	levels[level - 1]["level"][stage - 1]["completed"] = true


func get_carrot(level, stage) -> int:
	return levels[level - 1]["level"][stage - 1]["carrot_count"]
