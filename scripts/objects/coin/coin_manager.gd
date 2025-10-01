extends Node2D
class_name CoinManager

@export var world_node: Node2D
@export var coin_scene: PackedScene
@export var player_node: Node2D

var coins: Array = []

func _ready() -> void:
	pass
	
func setup(new: bool, saved_data: Dictionary):
	if new:
		_spawn_coins([])
	else:
		_spawn_coins(saved_data["coins"])
		

func genarate_save_data() -> Dictionary:
	var coin_positions: Array = []
	for inst in coins:
		coin_positions.append(
			{
				"x": inst.position.x, 
				"y": inst.position.y
			}
		)
	return {
		"coins": coin_positions
	}

func _spawn_coins(saved_coins: Array) -> void:
	if world_node == null or coin_scene == null:
		Log.log_error("CoinManager: world_node or coin_scene not assigned")
		return
	_clear_coins()
	if saved_coins and len(saved_coins) > 0:
		for coin_position in saved_coins:
			_spawn_coin(coin_position)
	else:
		for i in range(GameManager.count_coins):
			_spawn_coin({})
	
	
	

func _spawn_coin(coin_position: Dictionary) -> void:
	var coin_instance: Node2D = coin_scene.instantiate()
	if coin_position and coin_position != {}:
		
		coin_instance.position = Vector2(coin_position["x"], coin_position["y"])
	
		coin_instance.collected.connect(_on_coin_collected)
		
		coin_instance.player_node = player_node
	else:
		var coin_positions: Array = []
		for inst in coins:
			coin_positions.append(inst.position)
		if world_node == null or coin_scene == null:
			Log.log_error("CoinManager: world_node or coin_scene not assigned")
			return
			
		var new_position = world_node.get_random_ground_position()
		while new_position in coin_positions:
			new_position = world_node.get_random_ground_position()
		coin_instance.position = new_position
		
		coin_instance.collected.connect(_on_coin_collected)
		
		coin_instance.player_node = player_node
		
	add_child(coin_instance)

	coins.append(coin_instance)

func _on_coin_collected(instance: Node2D) -> void:
	GameManager.increase_player_score()
	coins.erase(instance)
	

func _clear_coins() -> void:
	for coin in coins:
		if is_instance_valid(coin):
			coin.queue_free()
	coins.clear()
