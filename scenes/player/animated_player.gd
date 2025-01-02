extends CharacterBody2D

var movement_speed = 1.5

func handle_input():
	
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_direction.x = 1.0
	elif Input.is_action_pressed("left"):
		move_direction.x = -1.0
	elif Input.is_action_pressed("down"):
		move_direction.y = 1.0
	elif Input.is_action_pressed("up"):
		move_direction.y = -1.0
	velocity = move_direction * movement_speed
	
	if velocity == Vector2.ZERO:
		pass
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", move_direction)
		$AnimationTree.set("parameters/Walk/blend_position", move_direction)


func _physics_process(delta: float) -> void:
	handle_input()
	# look_at(get_global_mouse_position())
	move_and_collide(velocity)
