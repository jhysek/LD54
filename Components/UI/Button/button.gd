extends Button

signal clicked
var  active = true

func _on_mouse_entered():
	if active:
		$Sfx/Hover.play()

func _on_mouse_exited():
	if active:
		$Sfx/Hover.play()

func _on_pressed():
	if active:
		$Sfx/Click.play()

func _on_click_finished():
	emit_signal("clicked")
