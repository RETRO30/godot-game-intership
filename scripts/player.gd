extends CharacterBody2D

@export var speed := 400
@export var dash_distance := 10 # in tiles
@export var world_node: Node2D

@export var dash_cooldown := 1.5 # seconds
var dash_time_left = 0.0

signal dash_time_changed(dash_cooldown: float, dash_time_left: float)

func _physics_process(_delta):
	_get_input()
	move_and_slide()


func _process(delta: float) -> void:
	if dash_time_left > 0:
		dash_time_left -= delta
		dash_time_changed.emit(dash_cooldown, dash_time_left)


func _get_input():
	var input_direction = Input.get_vector(
		"ui_left", 
		"ui_right", 
		"ui_up", 
		"ui_down"
	)
	velocity = input_direction * speed
	
	if Input.is_action_just_pressed("jump") and input_direction != Vector2.ZERO:
		if dash_time_left <= 0:
			_do_dash(input_direction)

func _do_dash(direction: Vector2) -> void:
	if world_node == null:
		print("ERRO: World node not assigned, dash can't be calculated")
		return
	var target_pos = world_node.get_nearest_free_cell(
		global_position, 
		direction, 
		dash_distance, 
		true
	)
	global_position = target_pos
	
	_start_dash_cooldown()

func _start_dash_cooldown() -> void:
	dash_time_left = dash_cooldown
