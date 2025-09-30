extends Resource

class_name PlayerSettingsStruct

@export var player_speed: float = 400
@export var teleport_cooldown: float = 1.5
@export var teleport_distance: int = 10 # in tiles

func validate() -> bool:
	var ok = true
	if player_speed < 0:
		Log.log_error("Player speed must be bigger than 0")
		ok = false
	if teleport_distance < 0:
		Log.log_error("Teleport distance must be bigger than 0")
		ok = false
	if teleport_cooldown < 0:
		Log.log_error("Teleport cooldown must be bigger than 0")
		ok = false
	return ok
	
func to_dict() -> Dictionary:
	return {
		"player_speed": player_speed,
		"teleport_cooldown": teleport_cooldown,
		"teleport_distance": teleport_distance,
	}

func from_dict(data: Dictionary) -> void:
	player_speed = data.get("player_speed", player_speed)
	teleport_cooldown = data.get("teleport_cooldown", teleport_cooldown)
	teleport_distance = data.get("teleport_distance", teleport_distance)
