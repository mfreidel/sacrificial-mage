extends Node2D

signal enemy_spawned

# Total number of enemies to spawn
@export var MAX_SPAWNS : int = 5

@onready var res_enemy = preload("res://scenes/entities/enemy.tscn")

var spawn_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _restart_spawner() -> void:
	if !($SpawnTimer.is_stopped()):
		$SpawnTimer.stop()
	spawn_count = 0
	$SpawnTimer.start()


func spawn_enemy() -> void:
	var inst_enemy = res_enemy.instantiate()
	inst_enemy.position = position
	inst_enemy.PATH_TARGET = get_parent().get_node("AnimatedPlayer")
	get_parent().get_node("EnemyContainer").add_child(inst_enemy)
	emit_signal("enemy_spawned")

func _on_spawn_timer_timeout() -> void:
	spawn_count += 1
	if spawn_count > MAX_SPAWNS:
		$SpawnTimer.stop()
	else:
		spawn_enemy()
