extends Node2D

@onready var res_enemy = preload("res://scenes/entities/enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_spawn_timer_timeout() -> void:
	var inst_enemy = res_enemy.instantiate()
	inst_enemy.position = position
	inst_enemy.PATH_TARGET = get_parent().get_node("AnimatedPlayer")
	get_parent().get_node("EnemyContainer").add_child(inst_enemy)
