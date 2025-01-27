extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Mountain_Range.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")
