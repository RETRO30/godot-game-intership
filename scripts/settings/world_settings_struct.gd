extends Resource
class_name WorldSettingsStruct

# world
@export var world_size: Vector2i = Vector2i(64, 64)

# coins
@export var count_coins: int = 20

func validate() -> bool:
	var ok = true
	if world_size.x < 20 or world_size.y < 20:
		Log.log_error("World size must be bigger or equal to (20, 20)")
		ok = false
	if count_coins < 1:
		Log.log_error("Count coins must be bigger or equal to 1")
		ok = false
	return ok

func to_dict() -> Dictionary:
	return {
		"world_size_x": world_size.x,
		"world_size_y": world_size.y,
		"count_coins": count_coins,
	}

func from_dict(data: Dictionary) -> void:
	world_size = Vector2i(
		data.get("world_size_x", world_size.x),
		data.get("world_size_y", world_size.y)
	)
	count_coins = data.get("count_coins", count_coins)
