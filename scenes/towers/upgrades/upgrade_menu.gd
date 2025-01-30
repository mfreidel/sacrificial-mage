extends PopupPanel

# Custom signal for telling the tower which upgrades to apply
signal apply_upgrades(names_list:Array)
var apply_names: Array = [] # intended to be sent in the signal

# Parent node should always be a tower
@onready var parent_tower = get_parent()
@onready var tower_upgrades_table: Dictionary
@onready var opt_container = $VBoxContainer/OptionsContainer

# Load in the customized CheckButton for upgrades
@onready var res_option = load("res://scenes/towers/upgrades/upgrade_option.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("interact"):
		hide()
func update_tower_upgrades_table():
	tower_upgrades_table = parent_tower.upgrades_table
	return tower_upgrades_table

func refresh_upgrade_options() -> void:
	# Reset the list of upgrades to apply
	apply_names = []
	$VBoxContainer/ApplyButton.disabled = false
	# Remove anything in OptionsContainer
	for item in opt_container.get_children():
		item.queue_free()
	# Add option buttons in OptionsContainer based on tower_upgrades_table
	for upgrade_name in update_tower_upgrades_table():
		var entry = tower_upgrades_table[upgrade_name]
		print("upgrade_menu.gd -- uprgrade entry found: " + str(entry))
		var button_text = entry["text"] + " (Cost=" + str(entry["upgrade_cost"]) + ")"
		#var button_text = "foobar"
		var inst_option = res_option.instantiate()
		inst_option.text = button_text
		inst_option.upgrade_name = upgrade_name
		inst_option.upgrade_cost  = entry["upgrade_cost"]
		if entry["is_applied"]:
			inst_option.button_pressed = true
			inst_option.disabled = true
		opt_container.add_child(inst_option)

func _on_about_to_popup() -> void:
	refresh_upgrade_options()


func _on_apply_button_pressed() -> void:
	$VBoxContainer/ApplyButton.disabled = true
	for upgrade_option in opt_container.get_children():
		if !(upgrade_option.disabled):
			if upgrade_option.button_pressed:
				apply_names.append(upgrade_option.upgrade_name)
	# done looping...
	if !(apply_names == []):
		apply_upgrades.emit(apply_names)
	refresh_upgrade_options()
		
