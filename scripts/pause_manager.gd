extends Node2D

var pause_menu_node: Control
var paused: bool = false

func _ready() -> void:
	pause_menu_node.continue_button_pressed.connect(_on_continue_pressed)
	
	
func switch_pause() -> void:
	paused = !paused
	get_tree().paused = paused
	pause_menu_node.visible = paused

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		switch_pause()
		
		
func _on_continue_pressed() -> void:
	switch_pause()
