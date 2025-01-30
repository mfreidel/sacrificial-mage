extends Node

var current_table: Dictionary

@onready var tower_parent = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_current_table()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_current_table():
	current_table = tower_parent.upgrades_table
	return current_table

func get_upgrade_record(upgrade_name:String):
	var table = get_current_table()
	var upgrade_record = table[upgrade_name]
	return upgrade_record

func is_upgrade_applied(upgrade_name:String):
	var check = false
	var upgrade_record = get_upgrade_record(upgrade_name)
	if upgrade_record["is_applied"] == true:
		check = true
	return check

func set_upgrade_is_applied(upgrade_name:String) -> void:
	tower_parent.upgrades_table[upgrade_name]["is_applied"] = true
