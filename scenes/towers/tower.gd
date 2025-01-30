extends StaticBody2D
class_name TowerNode
## tower.gd -- Common class for towers
##
## A collection of reusable functions and common variables for towers.
## Potentially can be used for other structures.
##
## This is **NOT** intended to be directly attached to objects. Other scripts 
## attached to a StaticBody2D node should extend this file instead 
## of the built-in StaticBody2D object.

# Exported vars
@export var DEFAULT_MAX_HEALTH = 15.0
@export var DEFAULT_BUILD_COST = 5.0

var MAX_HEALTH = DEFAULT_MAX_HEALTH

# All towers will have both health points and levels
var health = MAX_HEALTH

# Towers will need access to the level and player nodes
@onready var level_node = get_tree().get_root().get_node("Level")
@onready var player_node = get_tree().get_first_node_in_group("player")

func heal_from_player(health_val: float) -> void:
	player_node.damage_health(health_val)
	increase_health(health_val)
	
func increase_health(health_val: float) -> void:
	var new_health = health + health_val
	if new_health > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health = new_health

func damage_health(damage: float) -> void:
	health -= damage
	if health <= 0:
		queue_free()
