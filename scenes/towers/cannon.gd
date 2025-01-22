extends "res://scenes/towers/tower.gd"

@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")
@onready var cball_image = load("res://assets/sprites/cannonball.png")

# Make interaction area accessible here
@onready var interaction_area: InteractionArea = $InteractionArea

var facing_rot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

# Interaction options for the object
func _on_interact() -> void:
	$CannonMenu.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


func shoot():
	var instance = projectile.instantiate()
	var vert_offset = Vector2(-8, 0)
	instance.dir = facing_rot
	instance.zdex = z_index - 1
	instance.spawnPos = global_position
	
	if facing_rot == 0:
		instance.spawnPos += vert_offset
	instance.spawnRot = facing_rot
	instance.get_node("ProjectileSprite").texture = cball_image
	instance.get_node("ProjectileSprite").scale = Vector2(1, 1)
	level_node.add_child.call_deferred(instance)


func toggle_firing_timer() -> void:
	if $FiringTimer.is_stopped():
		$FiringTimer.start()
		print("cannon.gd -- FiringTimer started.")
	else:
		$FiringTimer.stop()
		print("cannon.gd -- FiringTimer stopped.")

func _on_firing_timer_timeout() -> void:
	shoot()


func _on_cannon_menu_firing_state_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if $FiringTimer.is_stopped():
			$FiringTimer.start()
			print("cannon.gd -- FiringTimer started.")
	else:
		if !($FiringTimer.is_stopped()):
			$FiringTimer.stop()
			print("cannon.gd -- FiringTimer stopped.")
