extends Node


# Scene managment
var current_scene: Node

func change_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child(scene)
	current_scene = scene

# Score managment
@export var player_score: int = 0
@export var coin_cost: int = 100

signal player_score_changed(value: int)

func increase_player_score() -> void:
	player_score += coin_cost
	Log.log_info("Score changed")
	player_score_changed.emit(player_score)
	
func reset_player_score() -> void:
	player_score = 0
	player_score_changed.emit(player_score)

@warning_ignore("unused_signal")
signal player_teleport_time_changed(
	teleport_cooldown: float, 
	teleport_time_left: float
)
