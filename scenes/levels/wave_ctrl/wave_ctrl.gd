extends Node

@export var WAVE_SECONDS : float = 240.0
@export var INTERIM_SECONDS : float = 60.0

var wave_number : int

# Get all spawners placed in the level.
@onready var spawners_list = get_tree().get_nodes_in_group("enemy_spawners")
@onready var enemy_list = get_tree().get_nodes_in_group("enemy")

func _ready() -> void:
	#reset_controller()
	# Level will initialize the wave starting
	pass
	

func _process(_delta: float) -> void:
	pass

func first_wave() -> void:
	wave_number = 1
	get_tree().call_group("enemy_spawners", "_initialize_spawner")
	restart_all_spawners()
	$WaveTimer.start()


func next_wave() -> void:
	wave_number += 1
	stop_timers()
	get_tree().call_group("enemy_spawners", "_increment_total_spawns")
	restart_all_spawners()
	$WaveTimer.start()
	print("wave_ctrl.gd -- Next Wave!")


func reset_controller() -> void:
	stop_timers()
	$WaveTimer.wait_time = WAVE_SECONDS
	$InterimTimer.wait_time = INTERIM_SECONDS
	first_wave()

func update_enemy_list():
	enemy_list = get_tree().get_nodes_in_group("enemy")
	return enemy_list

func restart_all_spawners() -> void:
	get_tree().call_group("enemy_spawners", "_restart_spawner")
	

func stop_timers() -> void:
	if !($WaveTimer.is_stopped()):
		$WaveTimer.stop()
	if !($InterimTimer.is_stopped()):
		$InterimTimer.stop()


func _on_wave_timer_timeout() -> void:
	$InterimTimer.start()
	print("wave_ctrl.gd -- Wave over!")


func _on_interim_timer_timeout() -> void:
	next_wave()
