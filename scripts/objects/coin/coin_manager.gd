extends Node2D
class_name CoinManager

@export var world_node: Node2D
@export var coin_scene: PackedScene
@export var player_node: Node2D

var coins: Array = []

func _ready() -> void:
	_spawn_coins()

func _spawn_coins() -> void:
	if world_node == null or coin_scene == null:
		Log.log_error("CoinManager: world_node or coin_scene not assigned")
		return
	_clear_coins()
	for i in range(Settings.data.world_settings.count_coins):
		_spawn_coin()

func _spawn_coin() -> void:
	var coin_positions: Array = []
	for inst in coins:
		coin_positions.append(inst.position)
	if world_node == null or coin_scene == null:
		Log.log_error("CoinManager: world_node or coin_scene not assigned")
		return
	
	var coin_instance: Node2D = coin_scene.instantiate()
	var new_position = world_node.get_random_ground_position()
	while new_position in coin_positions:
		new_position = world_node.get_random_ground_position()
	coin_instance.position = new_position
	
	coin_instance.collected.connect(_on_coin_collected)
	
	coin_instance.player_node = player_node
	
	add_child(coin_instance)

	
	
	coins.append(coin_instance)

func _on_coin_collected() -> void:
	Log.log_info("Coin collected!")
	GameManager.increase_player_score()

func _clear_coins() -> void:
	for coin in coins:
		if is_instance_valid(coin):
			coin.queue_free()
	coins.clear()
