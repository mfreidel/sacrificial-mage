extends Control


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu/start_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
