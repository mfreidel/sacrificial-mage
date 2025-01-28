extends Control

@onready var version_file_path = "res://VERSION.txt"

func _ready() -> void:
	var version_number = get_text_file_content(version_file_path)
	$MarginContainer/VBoxContainer/HBoxContainer/VersionStatus.text = version_number


func get_text_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Mountain_Range.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")
