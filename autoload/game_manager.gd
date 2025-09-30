extends Node


# Scene managment
var game_scene_path: String = "res://scenes/Game.tscn"
var main_menu_scene_path: String = "res://scenes/StartMenu.tscn"

func go_to_new_game() -> void:
	switch_scene(game_scene_path)
	
	
func go_to_main_menu() -> void:
	switch_scene(main_menu_scene_path)
	
func switch_scene(scene_path: String) -> void:
	var tree: SceneTree = get_tree()
	tree.paused = false
	get_tree().change_scene_to_file(scene_path)
	
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
