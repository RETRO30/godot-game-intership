extends Node2D
class_name EnemyManager

@export var world_node: Node2D
@export var enemy_scene: PackedScene
@export var player_node: Node2D

var coins: Array = []

func _ready() -> void:
	_spawn_coins()

func _spawn_coins() -> void:
	if world_node == null or enemy_scene == null:
		Log.log_error("CoinManager: world_node or enemy_scene not assigned")
		return
	#_clear_coins()
	for i in range(Settings.data.enemy_settings.enemy_count):
		_spawn_coin()

func _spawn_coin() -> void:
	var coin_positions: Array = []
	for inst in coins:
		coin_positions.append(inst.position)
	if world_node == null or enemy_scene == null:
		Log.log_error("CoinManager: world_node or enemy_scene not assigned")
		return
	
	var coin_instance: Node2D = enemy_scene.instantiate()
	var new_position = world_node.get_random_ground_position()
	while new_position in coin_positions:
		new_position = world_node.get_random_ground_position()
	coin_instance.world_node = world_node
	coin_instance.position = new_position
	
	#coin_instance.collected.connect(_on_coin_collected)
	
	coin_instance.player_node = player_node
	
	add_child(coin_instance)

	
	
	coins.append(coin_instance)

#func _on_coin_collected() -> void:
	#Log.log_info("Coin collected!")
	#GameManager.increase_player_score()
#
#func _clear_coins() -> void:
	#for coin in coins:
		#if is_instance_valid(coin):
			#coin.queue_free()
	#coins.clear()
