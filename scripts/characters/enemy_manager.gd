extends Node2D
class_name EnemyManager

@export var world_node: Node2D
@export var enemy_scene: PackedScene

var enemies: Array = []
var enemy_speed: float = Settings.data.enemy_settings.enemy_speed

func _ready() -> void:
	pass
	
func setup(new: bool, saved_data: Dictionary):
	if new:
		_spawn_enemies([])
	else:
		enemy_speed = saved_data["speed"]
		_spawn_enemies(saved_data["enemies"])

func genarate_save_data() -> Dictionary:
	var enemies_positions: Array = []
	for inst in enemies:
		enemies_positions.append(
			{
				"x": inst.position.x, 
				"y": inst.position.y
			}
		)
	return {
		"speed": Settings.data.enemy_settings.enemy_speed,
		"count": Settings.data.enemy_settings.enemy_count,
		"enemies": enemies_positions
	}

func _spawn_enemies(saved_enemies: Array) -> void:
	if world_node == null or enemy_scene == null:
		Log.log_error("enemyManager: world_node or enemy_scene not assigned")
		return
	_clear_enemies()
	if saved_enemies and len(saved_enemies) > 0:
		for enemy_position in saved_enemies:
			_spawn_enemy(enemy_position)
	else:
		for i in range(GameManager.count_coins):
			_spawn_enemy({})

func _spawn_enemy(enemy_position: Dictionary) -> void:
	var enemy_instance: CharacterBody2D = enemy_scene.instantiate()
	enemy_instance.world_node = world_node
	enemy_instance.speed = enemy_speed
	if enemy_position and enemy_position != {}:
		enemy_instance.position = Vector2(enemy_position["x"], enemy_position["y"])
	else:	
		var enemy_positions: Array = []
		for inst in enemies:
			enemy_positions.append(inst.position)
		if world_node == null or enemy_scene == null:
			Log.log_error("EnemyManager: world_node or enemy_scene not assigned")
			return
		var new_position = world_node.get_random_ground_position()
		while new_position in enemy_positions:
			new_position = world_node.get_random_ground_position()
		
		enemy_instance.position = new_position

	add_child(enemy_instance)
	
	enemies.append(enemy_instance)
	
	
func _clear_enemies() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()
