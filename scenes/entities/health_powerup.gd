extends CharacterBody2D

@onready var player_node = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	$AnimationPlayer.play("rotate")

func _physics_process(_delta) -> void:
	velocity = Vector2(0, 0)
	var collision = move_and_slide()
	if collision:
		var col_target = get_last_slide_collision().get_collider()
		if col_target is CharacterBody2D:
			#heal_player()
			queue_free()
