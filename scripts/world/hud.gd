extends CanvasLayer

@onready var score_label: Label = $Control/ScoreLabel
@onready var stamina_progress_bar = $Control/StaminaProgressBar


func _ready() -> void:
	score_label.text = str(
		0
		) + "/" + str(
		GameManager.coin_cost * Settings.data.world_settings.count_coins
	)
	GameManager.player_score_changed.connect(_on_score_changed)
	GameManager.player_teleport_time_changed.connect(_on_player_teleport_time_changed)


func _on_score_changed(value: int):
	Log.log_info("Score changed: " + str(value))
	score_label.text = str(
		value
		) + "/" + str(
		GameManager.coin_cost * Settings.data.world_settings.count_coins
	)
	
func _on_player_teleport_time_changed(teleport_cooldown: float, teleport_time_left: float):
	stamina_progress_bar.max_value = teleport_cooldown
	stamina_progress_bar.value = teleport_cooldown - teleport_time_left
