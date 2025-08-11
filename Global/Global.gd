extends Node

signal game_loaded

var coin_count: int = 990
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


var levels = [
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": false },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
	{ "carrot_count": 0, "completed": false, "isLocked": true },
]

signal coins_changed
signal carrot_changed


func add_coins(amount: int = 1):
	coin_count += amount
	emit_signal("coins_changed")


func remove_coins(amount: int = 1):
	coin_count -= amount
	emit_signal("coins_changed")


func add_carrot(level):
	levels[level]["carrot_count"] += 1
	emit_signal("carrot_changed")


func reset_carrot(level):
	levels[level]["carrot_count"] = 0

func complete_level(level_index: int, session_carrots: int):
	var previous_best = levels[level_index]["carrot_count"]
	if session_carrots > previous_best:
		levels[level_index]["carrot_count"] = session_carrots
		
	levels[level_index]["completed"] = true
	if level_index + 1 < levels.size():
		levels[level_index + 1]["isLocked"] = false
	
	save_game()
	
func load_level(level):
	var path = "res://Levels/level%d.tscn" % level
	var level_scene = load(path)
	if level_scene:
		get_tree().change_scene_to_packed(level_scene)
	else:
		push_error("Level scene not found: %s", % path)

const SAVE_PATH = "user://savegame.dat"
const SAVE_PASSWORD = "it's_a_secret_to_everyone"

func save_game():
	var save_date = {
		"upgrades": upgrades,
		"levels": levels,
		"coin_count": coin_count
	}
	
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, SAVE_PASSWORD)
	var json_string = JSON.stringify(save_date, "\t")
	file.store_string(json_string)
	print("Game Saved!")
	
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return
	
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, SAVE_PASSWORD)
	
	if file == null:
		print("Error opening file")
		return
	
	var json_string = file.get_as_text()
	var data = JSON.parse_string(json_string)
	
	if not data is Dictionary:
		print("Save data is corrupt")
		return
		
	if data.has("upgrades"):
		var loaded_upgrades = data["upgrades"]
		for key in loaded_upgrades:
			if upgrades.has(key):
				upgrades[key] = loaded_upgrades[key]
				
	if data.has("levels"):
		var loaded_levels = data["levels"]
		for i in range(min(levels.size(), loaded_levels.size())):
			levels[i] = loaded_levels[i]
			
	if data.has("coin_count"):
		coin_count = data["coin_count"]
	
	game_loaded.emit()
	print("Game loaded!")
