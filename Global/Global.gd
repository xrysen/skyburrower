extends Node

var coin_count: int = 0
var fire_rate: float = 0.3
var strength: int = 1
var max_health: int = 3
var current_health: int = 10
var magnet: float = 100.0
var luck: int = 1

var levels = [
	{ "level": [ { "carrot_count": 0, "completed": false}]}
]
 
signal coins_changed
signal carrot_changed

func add_coins(amount: int = 1):
	coin_count += amount
	emit_signal("coins_changed")
	
func add_carrot(level,stage):
	levels[level - 1]["level"][stage - 1]["carrot_count"] += 1
	emit_signal("carrot_changed")
	
func reset_carrot(level,stage):
	levels[level - 1]["level"][stage - 1]["carrot_count"] = 0
	
func mark_stage_complete(level,stage):
	levels[level - 1]["level"][stage - 1]["completed"] = true
	
func get_carrot(level, stage) -> int:
	return levels[level - 1]["level"][stage - 1]["carrot_count"]
	
	
	
