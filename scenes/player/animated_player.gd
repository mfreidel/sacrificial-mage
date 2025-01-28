extends CharacterBody2D

signal player_death

# exported vars
@export var DEFAULT_MAX_HEALTH = 20.0

# Set health vars based on DEFAULT_MAX_HEALTH
@onready var MAX_HEALTH = DEFAULT_MAX_HEALTH
@onready var health = MAX_HEALTH

# Variables for ranged attack
@onready var level_node = get_tree().get_root().get_node("Level")
@onready var projectile = load("res://scenes/entities/projectile.tscn")


# Variables for towers
@onready var res_statue = preload("res://scenes/towers/statue_tower.tscn")
@onready var res_cannon = preload("res://scenes/towers/cannon.tscn")
var build_area_obstacles = 0

# Variables for weapon switching
var player_weapon : int = 0
var weapons_list = ["melee", "ranged"]

# Equiping Towers works just like switching weapons
var selected_tower : int = 0
var towers_list = ["cannon", "statue"]


# Base damage value for melee attack
var base_melee_damage = 2.0

# Movement speed is used to calculate velocity while moving.
var movement_speed = 1.5

# facing_rot simulates object rotation
var facing_rot = 3.14159
# Player sprite should never rotate according to its properties.
# Instead, this value gets updated during movement handling to determine 
# which direction the sprite animation is facing

func set_new_spawn_vars() -> void:
	MAX_HEALTH = DEFAULT_MAX_HEALTH
	health = MAX_HEALTH

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
	
	# Tower switching input
	if Input.is_action_just_pressed("switch_tower"):
		next_tower()
	
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


func apply_buffs_from_statues() -> void:
	MAX_HEALTH = DEFAULT_MAX_HEALTH # Set MAX to DEFAULT right away
	var statues_list = get_tree().get_nodes_in_group("statue_towers") # Statue scene is pre-configured to be here
	if len(statues_list) > 0:
		for statue in statues_list:
			# Loop through a non-empty list of statues, adding each HEALTH_BUFF
			MAX_HEALTH += statue.HEALTH_BUFF

## Avoids casting yourself to death
func check_casting_cost(cost_val: float):
	var min_health = 1
	var health_after_cast = health - cost_val
	var check = false
	if health_after_cast >= min_health:
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
		if tower_name == "statue":
			place_statue()
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


func place_statue() -> void:
	# Make an instance of statue
	var inst_statue = res_statue.instantiate()
	var build_cost = inst_statue.BUILD_COST
	if check_casting_cost(build_cost):
		inst_statue.global_position = $BuildArea/BuildCollision.global_position
		level_node.add_child.call_deferred(inst_statue)
		damage_health(build_cost)
	else:
		inst_statue.queue_free()
		print("cannot place statue! (not enough health)")

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

func next_tower():
	if ((len(towers_list) - 1) == selected_tower):
		selected_tower = 0
	else:
		selected_tower += 1
	print("Switched towers to: " + towers_list[selected_tower])


func next_weapon():
	if ((len(weapons_list) - 1) == player_weapon):
		player_weapon = 0
	else:
		player_weapon += 1


func damage_health(damage):
	health -= damage
	print("HP: " + str(health))
	print("MAX_HEALTH: " + str(MAX_HEALTH))


func death() -> void:
	player_death.emit()


func increase_health(heal_amt: float) -> void:
	if !(health == MAX_HEALTH):
		var new_health = health + heal_amt
		if new_health > MAX_HEALTH:
			health = MAX_HEALTH
		else:
			health = new_health
		print("player.gd -- increase_health() -- Increased health to " + str(health))
	else:
		print("player.gd -- increase_health() -- Failed! Player already at max health")
	

func _physics_process(_delta: float) -> void:
	# Are you dead yet?
	if health <= 0:
		death()
	
	# Apply input handling
	handle_input()
	apply_buffs_from_statues()
	
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


func _on_score_controller_score_increased(new_score: int) -> void:
	$Camera2D/PlayerHUD._update_score_label(new_score)
