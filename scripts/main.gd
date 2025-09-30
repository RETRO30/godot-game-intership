extends Node2D


@export var world_scene: PackedScene
@export var player_scene: PackedScene
@export var coin_scene: PackedScene
@export var player_hud_scene: PackedScene
@export var coin_manager_scene: PackedScene

var world: Node2D
var player: Node2D
var coin_manager: Node2D
var player_hud: CanvasLayer


func _ready():
	var null_errors: int = 0
	if world_scene:
		world = world_scene.instantiate()
		world.position = Vector2(0.0, 0.0)
		add_child(world)
	else:
		null_errors += 1
		Log.log_error("World scene is not assigned")
	
	if player_scene:
		player = player_scene.instantiate()
		player.world_node = world
		player.position = world.get_random_ground_position()
		add_child(player)
	else:
		null_errors += 1
		Log.log_error("Player scene is not assigned")
	
	if coin_manager_scene:
		coin_manager = coin_manager_scene.instantiate()
		coin_manager.world_node = world
		coin_manager.coin_scene = coin_scene
		coin_manager.player_node = player
		add_child(coin_manager)
	else:
		null_errors += 1
		Log.log_error("Coin manager scene is not assigned")
		
	if player_hud_scene:
		player_hud = player_hud_scene.instantiate()
		add_child(player_hud)
	else:
		null_errors += 1
		Log.log_error("Player hud scene is not assigned")
	
	if null_errors > 0:
		Log.log_error("Scenes not assigned: " + str(null_errors))
		assert(null_errors == 0, "Assign scenes to main scene!")
