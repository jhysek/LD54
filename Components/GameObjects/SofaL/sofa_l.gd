extends "res://Components/GameObjects/Sofa/sofa.gd"


func _init():
	shape = [
		Vector2i(0,0),
		Vector2i(0,1),
		Vector2i(-1,1)
	]
	
	shape_size = Vector2(294, 248)
	super()
