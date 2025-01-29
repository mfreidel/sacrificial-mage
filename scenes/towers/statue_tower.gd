extends TowerNode

@export var HEALTH_BUFF = 10.0

# Make interaction area accessible here
@onready var interaction_area: InteractionArea = $InteractionArea

var BUILD_COST = 15.0

# A nested dictionary structure hold upgrade details.
var upgrades_table : Dictionary = {
	"increase_buff": {
		"text": "Increase max health buff.",
		"upgrade_cost": 15.0,
		"is_applied": false
	},
	"tower_health": {
		"text": "Increase statue health.",
		"upgrade_cost": 10.0,
		"is_applied": false
	},
	"regen_area": {
		"text": "Regenerate health when near statue.",
		"upgrade_cost": 30.0,
		"is_applied": false
	}
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

# Interaction options for the object
func _on_interact() -> void:
	$StatueMenu.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	



func _on_statue_menu_heal_pressed() -> void:
	var heal_cost = 5.0
	var new_health = health + heal_cost
	if new_health > MAX_HEALTH:
		heal_cost = MAX_HEALTH - health # Don't charge more than what gets used.
	heal_from_player(heal_cost)


func _on_statue_menu_upgrade_pressed() -> void:
	$StatueMenu.hide()
	$UpgradeMenu.popup()


func _on_upgrade_menu_apply_upgrades(names_list: Array) -> void:
	print("statue_tower.gd -- Received upgrade signal from menu containing: " + str(names_list))
