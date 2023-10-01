extends Node2D

func _ready():
	Transition.openScene()
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed('ui_restart'):
		Transition.switchTo("res://Scenes/game.tscn")
