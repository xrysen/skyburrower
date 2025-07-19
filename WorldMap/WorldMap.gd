extends Node2D

var fade := preload("res://Effects/fade.tscn").instantiate()

func _ready():
	$Label.text = "%d" % Global.coin_count
	add_child(fade)
	fade.fade_in()
