extends PopupPanel

signal firing_state_toggled(toggled_on: bool)
signal rotate_pressed
signal heal_pressed
signal upgrade_pressed

@onready var player = get_tree().get_first_node_in_group("player")
@onready var cannon = get_parent()
@onready var health_stat_label = $VBoxContainer/HealthContainer/HealthStatus
@onready var health_max_label = $VBoxContainer/HealthContainer/HealthMax
@onready var lvl_stat_label = $VBoxContainer/LevelContainer/LevelStatus


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


func _on_about_to_popup() -> void:
	$LabelRefresh.start()


func _on_popup_hide() -> void:
	$LabelRefresh.stop()


func _on_label_refresh_timeout() -> void:
	health_stat_label.text = str(cannon.health)
	health_max_label.text = str(cannon.MAX_HEALTH)
	lvl_stat_label.text = str(cannon.level)
