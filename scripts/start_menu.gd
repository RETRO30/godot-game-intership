extends Control

# buttons
@onready var new_game_button: Button = $List/NewGame
@onready var load_save_game_button: Button = $List/LoadSave
@onready var exit_button: Button = $List/Exit

# labels
@onready var top_text_label: Label = $TopText

# background
@onready var background_texture_rect: TextureRect = $Background


func _on_new_game_pressed() -> void:
	GameManager.go_to_new_game()
		


func _on_exit_pressed() -> void:
	get_tree().quit()
