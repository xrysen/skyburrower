extends Node2D

func _ready():
	$Label.text = "%d" % Global.coin_count
