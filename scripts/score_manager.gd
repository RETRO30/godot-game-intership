extends Node2D

signal score_changed(new_score: int)

var score: int = 0

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func reset_score() -> void:
	score = 0
	score_changed.emit(score)
