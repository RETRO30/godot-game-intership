extends Resource
class_name EnemySettingsStruct

@export var enemy_speed: float = 500
@export var enemy_count: int = 5

func validate() -> bool:
	var ok = true
	if enemy_count < 0:
		Log.log_error("Enemy speed must be bigger than 0")
		ok = false
	if enemy_speed < 0:
		Log.log_error("Enemy speed must be bigger than 0")
		ok = false
	return ok
	
func to_dict() -> Dictionary:
	return {
		"enemy_count": enemy_count,
		"enemy_speed": enemy_speed
	}
	
func from_dict(data: Dictionary) -> void:
	enemy_speed = data.get("enemy_speed", 500)
	enemy_count = data.get("enemy_count", 1)
