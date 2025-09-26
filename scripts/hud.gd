extends CanvasLayer

@export var score_manager_node: Node2D
@export var player_node: Node2D
@onready var score_label: Label = $Control/ScoreLabel
@onready var stamina_progress_bar = $Control/StaminaProgressBar

var stamina_timer: SceneTreeTimer


func _ready() -> void:
	if score_manager_node == null:
		print("ERROR: score_manager_node is not assigned")
		return
	score_manager_node.score_changed.connect(_on_score_changed)
	if player_node == null:
		print("ERROR: player_node is not assigned")
		return
	player_node.dash_time_changed.connect(_on_dash_time_changed)


func _on_score_changed(score: int):
	score_label.text = str(score)
	
func _on_dash_time_changed(dash_cooldown: float, dash_time_left: float):
	stamina_progress_bar.max_value = dash_cooldown
	stamina_progress_bar.value = dash_cooldown - dash_time_left
