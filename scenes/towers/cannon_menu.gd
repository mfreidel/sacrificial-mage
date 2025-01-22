extends PopupPanel

signal firing_state_toggled(toggled_on: bool)
signal rotate_pressed
signal heal_pressed
signal upgrade_pressed


func _ready() -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("interact"):
		hide()


func _on_toggle_fire_button_toggled(toggled_on: bool) -> void:
	firing_state_toggled.emit(toggled_on)


func _on_rotate_button_pressed() -> void:
	rotate_pressed.emit()


func _on_heal_button_pressed() -> void:
	heal_pressed.emit()


func _on_upgrade_button_pressed() -> void:
	upgrade_pressed.emit()
