extends CharacterBody2D

@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")

var movement_speed = 1.5
var facing_rot = 3.14159

func handle_input():
	
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_direction.x += 1.0
		facing_rot = 1.5708
	elif Input.is_action_pressed("left"):
		move_direction.x -= 1.0
		facing_rot = -1.5708
	elif Input.is_action_pressed("down"):
		move_direction.y += 1.0
		facing_rot = 3.14159
	elif Input.is_action_pressed("up"):
		move_direction.y -= 1.0
		facing_rot = 0.0
	if Input.is_action_just_pressed("attack"):
		shoot()
	velocity = move_direction * movement_speed
	
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", move_direction)
		$AnimationTree.set("parameters/Walk/blend_position", move_direction)

func shoot():
	var instance = projectile.instantiate()
	instance.dir = facing_rot
	instance.spawnPos = global_position
	instance.spawnRot = facing_rot
	level_node.add_child.call_deferred(instance)

func _physics_process(delta: float) -> void:
	handle_input()
	# look_at(get_global_mouse_position())
	move_and_collide(velocity)
