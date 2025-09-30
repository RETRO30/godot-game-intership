extends Node2D

# world
@export var world_scene: PackedScene
var world: Node2D

# player
@export var player_scene: PackedScene
@export var player_hud_scene: PackedScene
var player: Node2D
var player_hud: CanvasLayer

# coins
@export var coin_scene: PackedScene
@export var coin_manager_scene: PackedScene
var coin_manager: Node2D

# enemy
@export var enemy_scene: PackedScene 
@export var enemy_manager_scene: PackedScene
var enemy_manager: Node2D

# pause
@export var pause_menu_scene: PackedScene
@export var pause_manager_scene: PackedScene
var pause_menu_node: Control
var pause_manager_node: Node2D







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
	
	if enemy_manager_scene:
		enemy_manager = enemy_manager_scene.instantiate()
		enemy_manager.world_node = world
		enemy_manager.enemy_scene = enemy_scene
		enemy_manager.player_node = player
		add_child(enemy_manager)
	else:
		null_errors += 1
		Log.log_error("Coin manager scene is not assigned")
	
	if pause_menu_scene:
		pause_menu_node = pause_menu_scene.instantiate()
		pause_menu_node.visible = false
		pause_menu_node.process_mode = ProcessMode.PROCESS_MODE_WHEN_PAUSED
		player_hud.add_child(pause_menu_node)
	else:
		null_errors += 1
		Log.log_error("Pause menu scene is not assigned")
		
	if pause_manager_scene:
		pause_manager_node = pause_manager_scene.instantiate()
		pause_manager_node.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
		pause_manager_node.pause_menu_node = pause_menu_node
		add_child(pause_manager_node)
	else:
		null_errors += 1
		Log.log_error("Pause manager scene is not assigned")
	
	if null_errors > 0:
		Log.log_error("Scenes not assigned: " + str(null_errors))
		assert(null_errors == 0, "Assign scenes to main scene!")
		
		
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		pause_menu_node.visible = get_tree().paused
