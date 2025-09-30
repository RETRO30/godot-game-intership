extends Resource
class_name SettingsStruct

@export var world_settings: WorldSettingsStruct

@export var player_settings: PlayerSettingsStruct
@export var enemy_settings: EnemySettingsStruct


func _init() -> void:
	to_default()


func to_default() -> void:
	world_settings = WorldSettingsStruct.new()
	player_settings = PlayerSettingsStruct.new()
	enemy_settings = EnemySettingsStruct.new()


func to_dict() -> Dictionary:
	return {
		"world": world_settings.to_dict(),
		"player": player_settings.to_dict(),
		"enemy": enemy_settings.to_dict()
	}


func from_dict(data: Dictionary) -> bool:
	if data.has("world"):
		world_settings.from_dict(data["world"])
	if data.has("player"):
		player_settings.from_dict(data["player"])
	if data.has("enemy"):
		enemy_settings.from_dict(data["enemy"])
	var ok: bool = validate()
	return ok


func validate() -> bool:
	var objects_to_validate: Array = [
		world_settings,
		enemy_settings,
		player_settings
	]
	var ok: Array[bool] = []
	for object in objects_to_validate:
		ok.append(object and object.validate())
	
	return ok.all(func(n): return n)
