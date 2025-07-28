extends Node2D

func _ready():
	$TextureRect/Coins.text = str(Global.coin_count)
	

	
func _physics_process(_delta: float) -> void:
	$TextureRect/Coins.text = str(Global.coin_count)
	

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)


func _on_map_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://WorldMap/worldMap.tscn")
