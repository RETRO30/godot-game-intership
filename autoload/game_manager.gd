extends Node


# Scene managment
var game_scene_path: String = "res://scenes/Game.tscn"
var main_menu_scene_path: String = "res://scenes/StartMenu.tscn"

var is_new_game: bool = true
var saved_game: Dictionary = {}

func go_to_new_game() -> void:
	is_new_game = true
	saved_game = {}
	switch_scene(game_scene_path)
	
func go_to_saved_game() -> bool:
	var ok: bool = Save.load_game()
	if ok:
		is_new_game = false
		saved_game = Save.save_data
		switch_scene(game_scene_path)
		return ok
	else:
		return ok
	
func go_to_main_menu() -> void:
	switch_scene(main_menu_scene_path)
	
func switch_scene(scene_path: String) -> void:
	var tree: SceneTree = get_tree()
	tree.paused = false
	get_tree().change_scene_to_file(scene_path)
	
# Score managment
var player_score: int = 0
var coin_cost: int = 100
var count_coins: int = Settings.data.world_settings.count_coins

func reset_count_coins():
	count_coins = Settings.data.world_settings.count_coins


signal player_score_changed(value: int)

func set_player_score(value: int):
	player_score = value
	player_score_changed.emit(player_score)

func increase_player_score() -> void:
	set_player_score(player_score+coin_cost)
	
func reset_player_score() -> void:
	set_player_score(0)

@warning_ignore("unused_signal")
signal player_teleport_time_changed(
	teleport_cooldown: float, 
	teleport_time_left: float
)
