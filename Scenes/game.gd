extends Node2D

var steps = 0

func _ready():
	Transition.openScene()
	set_process_input(true)
	$Apartment/Mover.jumped.connect(update_step_counter)
	
func _input(event):
	if event.is_action_pressed('ui_restart'):
		Transition.switchTo("res://Scenes/game.tscn")

func update_step_counter():
	steps += 1
	$Screen/Steps/AnimationPlayer.play("Pulse")
	$Screen/Steps.text = "Steps: " + str(steps)
