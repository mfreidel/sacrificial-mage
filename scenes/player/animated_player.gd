extends CharacterBody2D

# exported vars
@export var MAX_HEALTH = 20.0

# Variables for ranged attack
@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")

# Variables for towers
@onready var res_cannon = preload("res://scenes/towers/cannon.tscn")
var build_area_obstacles = 0

# Set health based on MAX_HEALTH
var health = MAX_HEALTH

# Variables for weapon switching
var player_weapon : int = 0
var weapons_list = ["melee", "ranged"]

# Equiping Towers works just like switching weapons
var selected_tower : int = 0
var towers_list = ["cannon"]


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

## Handles all input in _physics_process for player
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
	
	# Attack input
	if Input.is_action_just_pressed("attack"):
		if (weapons_list[player_weapon] == "ranged"):
			shoot()
		elif (weapons_list[player_weapon] == "melee"):
			# Call movement animation. Animation will use a signal to call damage code
			$MeleeWeapon/MeleeAnimationTree.get("parameters/playback").travel("swing")
	
	# Build input is combined with verifing build area empty  
	if Input.is_action_just_pressed("build"):
		build_tower(towers_list[selected_tower])
	
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


## Avoids casting yourself to death
func check_casting_cost(cost_val: float):
	var check = false
	if cost_val < (health - cost_val + 1):
		check = true
	return check


func check_build_area_empty():
	var check = false
	if build_area_obstacles == 0:
		check = true
	return check


func build_tower(tower_name:String) -> void:
	if check_build_area_empty():
		if tower_name == "cannon":
			place_cannon()
	else:
		print("Cannot build cannon!") # Player can't see this  message


func place_cannon() -> void:
	# Make instance of cannon
	var inst_cannon = res_cannon.instantiate()
	var build_cost = inst_cannon.BUILD_COST
	
	# check the casting cost before placing in the scene
	if check_casting_cost(build_cost):
		# Place it in the center of BuildArea
		inst_cannon.global_position = $BuildArea/BuildCollision.global_position
		level_node.add_child.call_deferred(inst_cannon)
		damage_health(build_cost)
	else: # player can't afford it
		inst_cannon.queue_free() # Delete instance
		print("Cannon not placed! (not enough health)") # Player can't see this message


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


func damage_health(damage):
	health -= damage
	print("HP: " + str(health))
	if health <= 0:
		# Game over screen will be loaded here.
		print("GAME OVER!")
		queue_free() # many errors


func _physics_process(_delta: float) -> void:
	# Apply input handling
	handle_input()
	
	# Apply movement direction to MeleeWeapon rotation based on facing_rot
	$MeleeWeapon.rotation = facing_rot
	
	# Same for BuildArea rotation
	$BuildArea.rotation = facing_rot
	
	# Apply movement -- Not sure why I went with move_and_collied here instead of move_and_slide()
	move_and_collide(velocity)


func _on_build_area_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	build_area_obstacles += 1
	



func _on_build_area_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	build_area_obstacles -= 1
	if build_area_obstacles == 0:
		print("Build area has been freed of obstacles")
