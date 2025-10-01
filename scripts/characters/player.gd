extends CharacterBody2D
class_name Player

@export var world_node: World
@export var enemy_scene: PackedScene
@onready var camera: Camera2D = $Camera2D

signal game_over(win: bool)

# Settings
var speed: float
var teleport_distance: int # in tiles
var teleport_cooldown: float # seconds
var teleport_time_left = 0.0


func _ready() -> void:
	pass


func setup(new: bool, saved_data: Dictionary):
	if new:
		camera.limit_right = Settings.data.world_settings.world_size.x * 32
		camera.limit_bottom = Settings.data.world_settings.world_size.y * 32
		position = world_node.get_random_ground_position()
		speed = Settings.data.player_settings.player_speed
		teleport_distance = Settings.data.player_settings.teleport_distance
		teleport_cooldown = Settings.data.player_settings.teleport_cooldown
	else:
		speed = saved_data["speed"]
		position.x = saved_data["position"]["x"]
		position.y = saved_data["position"]["y"]
		teleport_distance = saved_data["teleport_distance"]
		teleport_cooldown = saved_data["teleport_cooldown"]
		camera.limit_right = saved_data["camera_limit_right"]
		camera.limit_bottom = saved_data["camera_limit_bottom"]

		
func genarate_save_data() -> Dictionary:
	return {
		"speed": speed,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"teleport_distance": teleport_distance,
		"teleport_cooldown": teleport_cooldown,
		"camera_limit_right": camera.limit_right,
		"camera_limit_bottom": camera.limit_bottom
	}

func _physics_process(_delta):
	_get_input()
	move_and_slide()


func _process(delta: float) -> void:
	if teleport_time_left > 0:
		teleport_time_left -= delta
		GameManager.player_teleport_time_changed.emit(
			teleport_cooldown,
			teleport_time_left
		)


func _get_input():
	var input_direction = Input.get_vector(
		"ui_left", 
		"ui_right", 
		"ui_up", 
		"ui_down"
	)
	velocity = input_direction * speed
	
	if Input.is_action_just_pressed("jump") and input_direction != Vector2.ZERO:
		if teleport_time_left <= 0:
			_do_teleport(input_direction)

func _do_teleport(direction: Vector2) -> void:
	if world_node == null:
		Log.log_error("World node not assigned, teleport can't be calculated")
		return
	var target_pos = world_node.get_nearest_free_cell(
		global_position, 
		direction, 
		teleport_distance, 
		true
	)
	global_position = target_pos
	
	_start_teleport_cooldown()

func _start_teleport_cooldown() -> void:
	teleport_time_left = teleport_cooldown

func _on_score_changed(value: int):
	if value == GameManager.count_coins * GameManager.coin_cost:
		game_over.emit(true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.scene_file_path == enemy_scene.resource_path:
		game_over.emit(false)
	
