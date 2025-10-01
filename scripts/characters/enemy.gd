extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
var world_node: Node2D

var speed := Settings.data.enemy_settings.enemy_speed

func _ready() -> void:
	agent.target_position = world_node.get_random_ground_position()

func _physics_process(_delta) -> void:
	if agent.is_navigation_finished():
		agent.target_position = world_node.get_random_ground_position()
	else:
		var next_pos = agent.get_next_path_position()
		var direction = (next_pos - position).normalized()
		velocity = direction * speed
		move_and_slide()
		
