extends Control


func _on_new_game_pressed() -> void:
	GameManager.go_to_new_game()


func _on_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()
	
	
func set_message(message: String):
	$List/Message.text = message


func _on_load_save_pressed() -> void:
	var ok = GameManager.go_to_saved_game()
	if not ok:
		set_message("No saves")
