extends CharacterBody2D


@export var HEALTH = 5.0

func damage_health(damage):
	HEALTH -= damage

func _physics_process(_delta):
	if HEALTH <= 0:
		queue_free() 
