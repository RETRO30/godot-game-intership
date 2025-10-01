extends Node2D
class_name PauseManager

var paused: bool = false

signal pause_menu_visible_switched(_visible: bool)

func _ready() -> void:
	pass

func switch_pause() -> void:
	paused = !paused
	get_tree().paused = paused
	pause_menu_visible_switched.emit(paused)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		switch_pause()

func _on_player_hud_pause_menu_continue_button_pressed() -> void:
	switch_pause()
