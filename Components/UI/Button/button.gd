extends Button

signal clicked

func _on_mouse_entered():
	$Sfx/Hover.play()

func _on_mouse_exited():
	$Sfx/Hover.play()

func _on_pressed():
	_on_click_finished()
	#$Sfx/Click.play()

func _on_click_finished():
	emit_signal("clicked")
