extends Node2D	

@export var player_node: Node2D

signal collected

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node:
		collected.emit()
		queue_free()
