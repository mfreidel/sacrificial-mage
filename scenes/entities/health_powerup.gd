extends CharacterBody2D

# Amount of health restored when picked up
@export var POWERUP_VALUE = 1.0
@export var DESPAWN_TIME = 7.0

@onready var player_node = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	$AnimationPlayer.play("rotate") # Animation only needs to be started.
	$DespawnTimer.wait_time = DESPAWN_TIME
	$DespawnTimer.start()

func _physics_process(_delta) -> void:
	# Disable the collision shape if player is at maximum health
	if player_node.health >= player_node.MAX_HEALTH:
		$PowerupColShape.disabled = true
	else:
		$PowerupColShape.disabled = false
	
	# Collision handling via move_and_slide()
	velocity = Vector2(0, 0) # Don't move
	var collision = move_and_slide()
	if collision:
		var col_target = get_last_slide_collision().get_collider()
		if col_target.is_in_group("player"): 
			player_node.increase_health(POWERUP_VALUE)
			print("health_powerup.gd -- Pickup collected!")
		else:
			print("health_powerup.gd -- BUG! :: Non-player collision with pickup!")
		queue_free()


func _on_despawn_timer_timeout() -> void:
	queue_free()
