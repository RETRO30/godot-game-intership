extends Node

var exe_path = OS.get_executable_path()
var exe_dir = exe_path.get_base_dir()
var SAVE_PATH := exe_dir.path_join("/saves/savegame.json")
var save_data: Dictionary

func _ready() -> void:
	Settings.ensure_dir(exe_dir.path_join("saves"))

func save_game(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	save_data = data

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	save_data = JSON.parse_string(file.get_as_text())
	file.close()
	return true
