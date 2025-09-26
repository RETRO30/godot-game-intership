extends Node2D	

signal collected

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("collected")
		queue_free()
