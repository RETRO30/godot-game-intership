extends Node

var exe_path = OS.get_executable_path()
var exe_dir = exe_path.get_base_dir()

var settings_path: String = exe_dir.path_join("/data/settings.cfg")

var data: SettingsStruct = SettingsStruct.new()

func _ready() -> void:
	ensure_dir(exe_dir.path_join("data"))
	var ok = load_settings()
	if not ok:
		Log.log_error("Settings not loaded")
		assert(ok, "Error loading setting, check " + settings_path)

func ensure_dir(path: String) -> void:
	var dir := DirAccess.open(exe_dir)
	if not dir.dir_exists(path):
		dir.make_dir_recursive(path)

func load_settings() -> bool:
	var config_file = ConfigFile.new()
	var err = config_file.load(settings_path)
	var ok: bool = true

	if err != Error.OK:
		var settings_dict = data.to_dict()
		_dict_to_file(settings_dict, config_file, true)
	else:
		var data_from_file: Dictionary = _file_to_dict(config_file)
		ok = data.from_dict(data_from_file)
		var data_to_file: Dictionary = data.to_dict()
		_dict_to_file(data_to_file, config_file, true)

	return ok


func _dict_to_file(dict: Dictionary, cfg: ConfigFile, save: bool = false) -> void:
	for section in dict.keys():
		for key in dict[section].keys():
			cfg.set_value(section, key, dict[section][key])
	if save:
		var err = cfg.save(settings_path)
		if err == Error.OK:
			Log.log_info("Settings saved succesfully: " + settings_path)
		else:
			Log.log_error("Settings not saved:" + str(err))


func _file_to_dict(cfg: ConfigFile) -> Dictionary:
	var result: Dictionary = {}
	for section in cfg.get_sections():
		result[section] = {}
		for key in cfg.get_section_keys(section):
			result[section][key] = cfg.get_value(section, key)
	return result
