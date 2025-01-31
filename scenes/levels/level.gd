extends Node2D

func _ready() -> void:
	restart_level()

func respawn_player() -> void:
	$AnimatedPlayer.set_new_spawn_vars()
	$AnimatedPlayer.global_position = $PlayerRespawn.global_position

func reset_controllers() -> void:
	$ScoreController._reset_score()
	$WaveController.reset_controller()

func clear_level() -> void:
	# Kill all enemies right away
	get_tree().call_group("enemy", "queue_free")
	
	# Ensure that editor-placed towers not visible
	$LevelTowers.visible = false
	
	# Get a list of editor-placed towers
	var level_tower_nodes = $LevelTowers.get_children()
	
	# loop through all towers, delete everthing except the editor-placed towers
	for tower_node in get_tree().get_nodes_in_group("all_towers"):
		if !(tower_node in level_tower_nodes):
			tower_node.queue_free()
	
	# duplicate the invisible editor placed towers into the level
	for editor_tower in level_tower_nodes:
		editor_tower.LEVEL_TOWER = false # set the before duplicating
		var copied_tower = editor_tower.duplicate()
		add_child(copied_tower)
		editor_tower.LEVEL_TOWER = true # re-set when done

func restart_level() -> void:
	clear_level()
	respawn_player()
	reset_controllers()


func _add_points_to_score(incr_val:int) -> void:
	$ScoreController._increase_score(incr_val)

func _get_current_score():
	return $ScoreController.current_score

func get_wave_number():
	return $WaveController.wave_number

func get_player_message():
	return $AnimatedPlayer.message
