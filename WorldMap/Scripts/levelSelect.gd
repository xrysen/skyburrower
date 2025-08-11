extends TextureButton

@export var level_index: int
@onready var lock_icon = $LockIcon
@onready var carrot_container = $CarrotContainer
@onready var number_label = $LevelNumber
var full_carrot = preload("res://WorldMap/Assets/lsCarrotFull.png") 
var empty_carrot = preload("res://WorldMap/Assets/lsCarrotEmpty.png")

func _ready():
	Global.game_loaded.connect(update_button)
	update_button()
	
func update_button():
	var level_data = Global.levels[level_index]
	lock_icon.visible = level_data.isLocked
	carrot_container.visible = !level_data.isLocked
	disabled = level_data.isLocked
	number_label.text = str(level_index) if not level_data.isLocked else ""
	
	show_carrots(level_data.carrot_count)
	
func show_carrots(amount: int):
	var carr_nodes = [
		$CarrotContainer/TopLeft,
		$CarrotContainer/CenterLeft,
		$CarrotContainer/Center,
		$CarrotContainer/CenterRight,
		$CarrotContainer/TopRight
	]
	
	for i in range(carr_nodes.size()):
		if i < amount:
			carr_nodes[i].texture = full_carrot
		else:
			carr_nodes[i].texture = empty_carrot


func _on_pressed() -> void:
	print("click")
	if not Global.levels[level_index].isLocked:
		Global.load_level(level_index)
	else:
		print("Error")
