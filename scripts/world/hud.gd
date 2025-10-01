extends CanvasLayer
class_name PlayerHUD

@onready var score_label: Label = $GameHud/ScoreLabel
@onready var stamina_progress_bar = $GameHud/StaminaProgressBar


func _ready() -> void:
	score_label.text = str(
		0
		) + "/" + str(
		GameManager.coin_cost * GameManager.count_coins
	)
	GameManager.player_score_changed.connect(_on_score_changed)
	GameManager.player_teleport_time_changed.connect(_on_player_teleport_time_changed)


func _on_score_changed(value: int):
	score_label.text = str(
		value
		) + "/" + str(
		GameManager.coin_cost * GameManager.count_coins
	)
	
func _on_player_teleport_time_changed(teleport_cooldown: float, teleport_time_left: float):
	stamina_progress_bar.max_value = teleport_cooldown
	stamina_progress_bar.value = teleport_cooldown - teleport_time_left


signal pause_menu_continue_button_pressed
func _on_pause_menu_continue_button_pressed() -> void:
	pause_menu_continue_button_pressed.emit()
	


func _on_pause_manager_pause_menu_visible_switched(_visible: bool) -> void:
	$PauseMenu.visible = _visible


func _on_final_manager_show_end_game(message: String) -> void:
	$FinalMenu.set_message(message)
	$FinalMenu.visible = true
	

signal game_saved
func _on_pause_menu_save_button_pressed() -> void:
	game_saved.emit()
