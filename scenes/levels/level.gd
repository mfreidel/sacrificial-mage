extends Node2D

func _ready() -> void:
	restart_level()

func respawn_player() -> void:
	$AnimatedPlayer.set_new_spawn_vars()
	$AnimatedPlayer.global_position = $PlayerRespawn.global_position

func restart_level() -> void:
	get_tree().call_group("enemy", "queue_free")
	respawn_player()
	$WaveController.reset_controller()
	
