extends Node2D

var final_menu_node: Control
var game_over: bool = false


func stop_game():
	get_tree().paused = true

signal show_end_game(message: String)
func _on_player_game_over(win: bool) -> void:
	var message = ""
	if win:
		message = "You win!"
	else:
		message = "Game over! You lose. Be careful next time."
	stop_game()
	show_end_game.emit(message)
