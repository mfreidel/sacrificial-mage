extends Node

var current_score : int = 0

func _ready() -> void:
	pass

func _reset_score() -> void:
	current_score = 0

func _increase_score(incr_val:int):
	current_score += incr_val
	return current_score

func _get_current_score():
	return current_score
