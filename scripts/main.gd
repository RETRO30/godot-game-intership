extends Node2D

@onready var world = $World
@onready var player = $Player

func _ready():
	var spawn_pos = world.get_random_ground_position()
	player.position = spawn_pos
