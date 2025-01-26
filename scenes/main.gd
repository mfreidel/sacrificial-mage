extends Node
## This might be useful for a sort of "splash screen" when launching, or
## maybe establishing some runtime variables.
## For now, it just loads the StartMenu scene

func _ready() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/start_menu/start_menu.tscn")
