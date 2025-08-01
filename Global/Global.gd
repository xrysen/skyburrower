extends Node

var coin_count: int = 100
var fire_rate: float = 0.5
var strength: int = 1
var max_health: int = 3
var magnet: float = 25.0
var luck: int = 1
var speed: float = 3.0
var num_bullets: int
const BASE_COST: int = 100

var upgrades = {
	"health": {"level": 0, "cost": 100, "multi": 50},
	"strength": {"level": 0, "cost": 100, "multi": 50},
	"fire_rate": {"level": 0, "cost": 100, "multi": 50},
	"magnet": {"level": 0, "cost": 100, "multi": 50},
	"luck": {"level": 0, "cost": 100, "multi": 50},
	"num_bullets": {"level": 0, "cost": 100, "multi": 100},
	"speed": {"level": 0, "cost": 100, "multi": 50}
}


func apply_upgrades():
	max_health = 3 + upgrades["health"]["level"]
	strength = 1 + upgrades["strength"]["level"]
	fire_rate = 0.5 - (upgrades["fire_rate"]["level"] * 0.05)
	magnet = 25.0 + (upgrades["magnet"]["level"] * 10.0)
	luck = 1 + (upgrades["luck"]["level"])
	speed = 3.0 + (upgrades["speed"]["level"] * 1.5)
	num_bullets = upgrades["num_bullets"]["level"]


func upgrade_formula(upgrade) -> int:
	return (
		BASE_COST
		+ (upgrades[upgrade]["level"] * upgrades[upgrade]["level"] * upgrades[upgrade]["multi"])
	)


func apply_upgrade_cost():
	upgrades["health"]["cost"] = upgrade_formula("health")
	upgrades["strength"]["cost"] = upgrade_formula("strength")
	upgrades["fire_rate"]["cost"] = upgrade_formula("fire_rate")
	upgrades["magnet"]["cost"] = upgrade_formula("magnet")
	upgrades["luck"]["cost"] = upgrade_formula("luck")
	upgrades["speed"]["cost"] = upgrade_formula("speed")
	upgrades["num_bullets"]["cost"] = upgrade_formula("num_bullets")


var levels = [{"level": [{"carrot_count": 0, "completed": false}]}]

signal coins_changed
signal carrot_changed


func add_coins(amount: int = 1):
	coin_count += amount
	emit_signal("coins_changed")


func remove_coins(amount: int = 1):
	coin_count -= amount
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
