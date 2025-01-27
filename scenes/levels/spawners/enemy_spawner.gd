extends Node2D

signal enemy_spawned

# Editor vars
@export var DEFAULT_TOTAL_SPAWNS : int = 3
@export var WAVE_INCREMENT : int = 1

# Spawn control vars
var total_spawns : int
var spawn_count : int = 0

# Enemy resource
@onready var res_enemy = preload("res://scenes/entities/enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialize_spawner()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _initialize_spawner() -> void:
	total_spawns = DEFAULT_TOTAL_SPAWNS
	print("enemy_spawner.gd -- total_spawns incremented to " + str(total_spawns))

func _restart_spawner() -> void:
	if !($SpawnTimer.is_stopped()):
		$SpawnTimer.stop()
	spawn_count = 0
	spawn_enemy()
	$SpawnTimer.start()

func _increment_total_spawns() -> void:
	total_spawns += WAVE_INCREMENT

func spawn_enemy() -> void:
	var inst_enemy = res_enemy.instantiate()
	inst_enemy.position = position
	inst_enemy.PATH_TARGET = get_parent().get_node("AnimatedPlayer")
	get_parent().get_node("EnemyContainer").add_child(inst_enemy)
	spawn_count += 1
	enemy_spawned.emit()

func _on_spawn_timer_timeout() -> void:
	if spawn_count >= total_spawns:
		$SpawnTimer.stop()
	else:
		spawn_enemy()
