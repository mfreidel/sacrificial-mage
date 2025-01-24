extends TowerNode

@export var HEALTH_BUFF = 10.0


@onready var projectile = load("res://scenes/entities/projectile.tscn")
@onready var cball_image = load("res://assets/sprites/cannonball.png")

# Make interaction area accessible here
@onready var interaction_area: InteractionArea = $InteractionArea



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
