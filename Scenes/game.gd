extends Node2D

var steps = 0

func _ready():
	$Screen/Finished.modulate = Color('ffffff', 0)
	$Screen/Finished/StarButton.active = false 
	Transition.openScene()
	set_process_input(true)
	$Apartment/Mover.jumped.connect(update_step_counter)
	$Apartment/Mover.picked.connect(hide_help)
	$Apartment/Mover.dropped.connect(check_wining_condition)
	
func _input(event):
	if event.is_action_pressed('ui_restart'):
		Transition.switchTo("res://Scenes/game.tscn")

func update_step_counter():
	steps += 1
	$Screen/Steps/AnimationPlayer.play("Pulse")
	$Screen/Steps.text = "Steps: " + str(steps)

func hide_help():
	$Apartment/Mover.picked.disconnect(hide_help)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Apartment/Controls, 'modulate', Color('ffffff', 0), 5)

func check_wining_condition():
	var map = $Apartment
	var blockers = map.get_blockers(null)

	for x in range(-7, -3):
		for y in range(11,15):
	#for x in range(-7, -6):
	#	for y in range(11,13):
			print(">>> " + str(Vector2i(x, y)))
			if !map.is_pos_blocked(blockers, Vector2i(x, y)):
				print("POSITION " + str(x) + "x" + str(y) + " IS EMPTY")
				return false
	
	game_finished()

func game_finished():
	$Screen/Finished/Label2.text = "You moved your apartment in\n\n" + str(steps) + " steps.\n\nNot bad!"
	$Apartment/Mover.freeze()
	$Screen/Finished/StarButton.active = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Screen/Finished, 'modulate', Color('ffffff', 1), 2)


func _on_star_button_clicked():
	$Screen/Finished.hide()
	Transition.switchTo("res://Scenes/game.tscn")


func _on_h_slider_value_changed(value):
	$Music.volume_db = value - 50
