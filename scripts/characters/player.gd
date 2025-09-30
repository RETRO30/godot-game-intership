extends CharacterBody2D

@export var world_node: Node2D
@onready var camera: Camera2D = $Camera2D

# Settings
var speed := Settings.data.player_settings.player_speed
var teleport_distance := Settings.data.player_settings.teleport_distance # in tiles
var teleport_cooldown := Settings.data.player_settings.teleport_cooldown # seconds
var teleport_time_left = 0.0


func _ready() -> void:
	camera.limit_right = Settings.data.world_settings.world_size.x * 32
	camera.limit_bottom = Settings.data.world_settings.world_size.y * 32



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
