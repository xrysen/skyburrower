extends Node

var coin_count: int = 0
var fire_rate: float = 0.3
var strength: int = 1
var max_health: int = 10
var current_health: int = 10
var magnet: float = 100.0
var luck: int = 1
 
signal coins_changed

func add_coins(amount: int = 1):
	coin_count += amount
	emit_signal("coins_changed")
	
