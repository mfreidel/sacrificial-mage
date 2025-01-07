extends CharacterBody2D

# Variables for ranged attack
@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")

# Variables for weapon switching
var player_weapon = 0
var weapons_list = ["melee", "ranged"]

# Base damage value for melee attack
var base_melee_damage = 2.0

# Movement speed is used to calculate velocity while moving.
var movement_speed = 1.5

# facing_rot simulates object rotation
var facing_rot = 3.14159
# Player sprite should never rotate according to its properties.
# Instead, this value gets updated during movement handling to determine 
# which direction the sprite animation is facing


func _ready():
	pass

func handle_input():
	
	var move_direction = Vector2.ZERO
	
	# Movement input
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
	
	# Weapon switching input
	if Input.is_action_just_pressed("switch_weapon"):
		next_weapon()
	
	# Apply movement direction to MeleeWeapon rotation based on facing_rot
	$MeleeWeapon.rotation = facing_rot
	
	# Attack input
	if Input.is_action_just_pressed("attack"):
		if (weapons_list[player_weapon] == "ranged"):
			shoot()
		elif (weapons_list[player_weapon] == "melee"):
			# Call movement animation. Animation will use a signal to call damage code
			$MeleeWeapon/MeleeAnimationTree.get("parameters/playback").travel("swing")
	
	# Calculate velocity
	velocity = move_direction * movement_speed
	
	# Movement animation
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", move_direction)
		$AnimationTree.set("parameters/Walk/blend_position", move_direction)
	# 
	# END OF handle_input() function

func shoot():
	var instance = projectile.instantiate()
	instance.dir = facing_rot
	instance.spawnPos = global_position
	instance.spawnRot = facing_rot
	level_node.add_child.call_deferred(instance)
	
func melee_damage(target_object):
	if target_object is CharacterBody2D:
		# Making some assumptions here. This could probably use some improvement.
		print("Hit! :: " + str(target_object))
		target_object.HEALTH -= base_melee_damage

func next_weapon():
	if ((len(weapons_list) - 1) == player_weapon):
		player_weapon = 0
	else:
		player_weapon += 1

func _physics_process(_delta: float) -> void:
	handle_input()
	move_and_collide(velocity)
