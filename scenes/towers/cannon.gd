extends "res://scenes/towers/tower.gd"

@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")
@onready var cball_image = load("res://assets/sprites/cannonball.png")

var facing_rot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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


func _on_firing_timer_timeout() -> void:
	shoot()
