extends Node2D

# map settings
@export var width: int = 64
@export var height: int = 64

# generation settings
@export var wall_threshold: float = 0.56
@export var frequency: float = 0.08

var generation_seed: int = randi()
var noise := FastNoiseLite.new()

@onready var ground_layer: TileMapLayer = $Ground
@onready var wall_layer: TileMapLayer = $Walls
@onready var highlight_layer: Node2D = $HighlightLayer

func _ready() -> void:
	_generate_map()

func _generate_map() -> void:
	ground_layer.clear()
	wall_layer.clear()

	noise.seed = generation_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = frequency
	var source_id := ground_layer.tile_set.get_source_id(0)

	for y in range(height):
		for x in range(width):
			var v := noise.get_noise_2d(float(x), float(y))
			var nv := (v + 1.0) * 0.5

			if x == 0 or y == 0 or x == width - 1 or y == height - 1:
				wall_layer.set_cell(Vector2i(x, y), source_id, Vector2i(1, 0))
			elif nv > wall_threshold:
				wall_layer.set_cell(Vector2i(x, y), source_id, Vector2i(1, 0))
			else:
				ground_layer.set_cell(Vector2i(x, y), source_id, Vector2i(0, 0))
		
		
func get_random_ground_position() -> Vector2:
	var ground_cells = ground_layer.get_used_cells()
	var candidates: Array[Vector2i] = []
	for cell in ground_cells:
		if wall_layer.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
			candidates.append(cell)

	if candidates.is_empty():
		return Vector2.ZERO

	var chosen = candidates.pick_random()
	var tile_size = ground_layer.tile_set.tile_size
	return chosen * tile_size + tile_size/2
	


func _highlight_cell(cell: Vector2i, duration: float = 0.2) -> void:
	var tile_size = ground_layer.tile_set.tile_size
	var highlight = ColorRect.new()
	highlight.color = Color(0.0, 0.6, 1.0, 0.502)
	highlight.size = tile_size
	highlight.position = cell * tile_size
	highlight_layer.add_child(highlight)

	# Через duration удаляем подсветку
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(highlight):
		highlight.queue_free()
	
func get_nearest_free_cell(
	start_pos: Vector2,
	direction: Vector2, 
	max_distance: int = 3, 
	effects: bool = false
) -> Vector2:
	var tile_size = ground_layer.tile_set.tile_size
	var start_cell = ground_layer.local_to_map(start_pos)

	for i in range(1, max_distance + 1):
		var target_cell = start_cell + Vector2i(direction) * i
		
		if effects:
			_highlight_cell(target_cell)
		
		if target_cell.x < 0 or target_cell.y < 0 or target_cell.x >= width or target_cell.y >= height:
			break

		if wall_layer.get_cell_atlas_coords(target_cell) == Vector2i(-1, -1):
			return target_cell * tile_size + tile_size / 2

	return start_pos
