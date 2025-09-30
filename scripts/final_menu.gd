extends Control


func _on_new_game_pressed() -> void:
	GameManager.go_to_new_game()


func _on_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()
