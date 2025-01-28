extends Node

signal score_increased(new_score:int)

var current_score : int = 0

func _ready() -> void:
	pass

func _reset_score() -> void:
	current_score = 0

func _increase_score(incr_val:int) -> void:
	current_score += incr_val
	score_increased.emit(current_score)
	print("score_ctrl.gd -- Score increased to: " + str(current_score))
