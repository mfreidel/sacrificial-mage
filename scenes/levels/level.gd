extends Node2D

func _ready() -> void:
	restart_level()

func respawn_player() -> void:
	$AnimatedPlayer.set_new_spawn_vars()
	$AnimatedPlayer.global_position = $PlayerRespawn.global_position

func restart_level() -> void:
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("all_towers", "queue_free")
	respawn_player()
	$ScoreController._reset_score()
	$WaveController.reset_controller()
	

func _add_points_to_score(incr_val:int) -> void:
	$ScoreController._increase_score(incr_val)

func _get_current_score():
	return $ScoreController.current_score
