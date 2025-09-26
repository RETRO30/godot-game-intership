extends Node2D

@export var world_node: Node2D
@export var player_node: Node2D
@export var score_manager_node: Node2D

@onready var coin: Node2D = $Coin

#settings
@export var coin_count: int = 20
@export var coin_cost: int = 100

var coins = []

func _ready() -> void:
	_spawn_coins()


func _spawn_coins():	
	_spawn_coin(coin)
	for i in range(1, coin_count):
		_spawn_coin(null)

func _spawn_coin(coin_object: Node2D):
	if world_node == null:
		print("ERROR: world_node is not assigned")
		return
	var new_position: Vector2 = world_node.get_random_ground_position()
	if coin_object == null:
		coin_object = coin.duplicate()
		add_child(coin_object)
	coin_object.collected.connect(_on_coin_collected)
	coin_object.position = new_position
	
	
func _on_coin_collected() -> void:
	if score_manager_node == null:
		print("ERROR: score_manager_node is not assigned")
		return
	score_manager_node.add_score(coin_cost)
