extends Node2D
class_name World

# map settings
var width: int = Settings.data.world_settings.world_size.x
var height: int = Settings.data.world_settings.world_size.y

# generation settings
var wall_threshold: float = 0.55
var frequency: float = 0.19

var generation_seed: int = randi()
var noise := FastNoiseLite.new()

@onready var ground_layer: TileMapLayer = $Ground
@onready var wall_layer: TileMapLayer = $Walls
@onready var highlight_layer: Node2D = $HighlightLayer

func _ready() -> void:
	pass
	
func setup(new: bool, saved_data: Dictionary):
	if new == false:
		width = saved_data["width"]
		height = saved_data["height"]
		wall_threshold = saved_data["wall_threshold"]
		frequency = saved_data["frequency"]
		generation_seed = saved_data["generation_seed"]
	_generate_map()
		
func genarate_save_data() -> Dictionary:
	return {
		"width": width,
		"height": height,
		"wall_threshold": wall_threshold,
		"frequency": frequency,
		"generation_seed": generation_seed
	}


func _generate_map() -> void:
	ground_layer.clear()
	wall_layer.clear()

	noise.seed = generation_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = frequency
	var source_id := ground_layer.tile_set.get_source_id(0)

	# --- генерация шума ---
	for y in range(height):
		for x in range(width):
			var v := noise.get_noise_2d(float(x), float(y))
			var nv := (v + 1.0) * 0.5
			
			var cell = Vector2i(x, y)
			
			if x == 0 or y == 0 or x == width - 1 or y == height - 1:
				wall_layer.set_cell(cell, source_id, Vector2i(1, 0)) # рамка мира
			elif nv > wall_threshold:
				wall_layer.set_cell(cell, source_id, Vector2i(1, 0)) # стена
			else:
				ground_layer.set_cell(cell, source_id, Vector2i(0, 0)) # земля

	# postprocessing
	ensure_connected_area(source_id)


func ensure_connected_area(source_id: int) -> void:
	var visited := {}
	var ground_areas: Array = []

	for y in range(height):
		for x in range(width):
			var cell := Vector2i(x, y)
			if ground_layer.get_cell_source_id(cell) != -1 and not visited.has(cell):
				var area = flood_fill(cell, visited)
				ground_areas.append(area)

	if ground_areas.size() <= 1:
		return

	ground_areas.sort_custom(func(a, b): return a.size() > b.size())

	for i in range(1, ground_areas.size()):
		for c in ground_areas[i]:
			ground_layer.erase_cell(c)
			wall_layer.set_cell(c, source_id, Vector2i(1,0))


func flood_fill(start: Vector2i, visited: Dictionary) -> Array:
	var queue: Array = [start]
	var area: Array = []

	while queue.size() > 0:
		var c: Vector2i = queue.pop_front()
		if visited.has(c):
			continue
		visited[c] = true

		if ground_layer.get_cell_source_id(c) == -1:
			continue

		area.append(c)

		for dir in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			var nc = c + dir
			if nc.x >= 0 and nc.y >= 0 and nc.x < width and nc.y < height:
				queue.append(nc)

	return area


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


func _highlight_cell(
	cell: Vector2i, 
	duration: float = 0.2, 
	color: Color = Color(0.0, 0.6, 1.0, 0.502)
) -> void:
	var tile_size = ground_layer.tile_set.tile_size
	var highlight = ColorRect.new()
	highlight.color = color
	highlight.size = tile_size
	highlight.position = cell * tile_size
	highlight_layer.add_child(highlight)

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
	
