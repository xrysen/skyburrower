extends Node

func _ready():
	await get_tree().process_frame  # Ensure everything is rendered
	var viewport := get_viewport()
	var image := viewport.get_texture().get_image()
	image.save_png("res://screenshot.png")
	print("Saved to res://screenshot.png")
	get_tree().quit()  # Optional: exit if running as a one-off export
