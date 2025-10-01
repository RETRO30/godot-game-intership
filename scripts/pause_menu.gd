extends Control

@onready var continue_button: Button = $List/Continue
@onready var save_button: Button = $List/Save
@onready var main_menu_button: Button = $List/MainMenu

signal continue_button_pressed

func _on_continue_pressed() -> void:
	continue_button_pressed.emit()


func _on_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()

signal save_button_pressed
func _on_save_pressed() -> void:
	save_button_pressed.emit()
