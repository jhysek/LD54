extends "res://Components/GameObjects/Furniture/furniture.gd"
var Indicator = load("res://Components/GameObjects/Indicator/indicator.tscn")

@export var DEBUG = false

func _init():
	shape = [
		Vector2i(0,0),
		Vector2i(0,1)
	]
	
	shape_size = Vector2(294, 248)
	super()

	
func _ready():
	super()
	
	if DEBUG:
		set_process_input(true)
		$AnimationPlayer.play("Pick")
		draw_indicator()
		print("MAP POS: " + str(map_pos))
	
func rotate_from(pivot_pos, angle):
	var new_shape = []
	for shape_pos in shape:
		var relative_pos = shape_pos #map_pos + shape_pos - pivot_pos
		print("SHAPE POS: " + str(shape_pos) + "    relative pos from " + str(pivot_pos) + "  =  " + str(relative_pos))
		print(str(relative_pos) + " => " + str(Vector2(relative_pos).rotated(angle)))
		new_shape.append(Vector2i(Vector2(relative_pos).rotated(angle).round()))
		
	print("SHAPE: " + str(shape) + " ROTATED: " + str(new_shape))
	shape = new_shape
	
	#if angle > 0:
	#	rotate_shape(Vector2i.RIGHT)
		
	#if angle < 0:
	#	rotate_shape(Vector2i.LEFT)
	
func _input(event):
	if not DEBUG:
		return
		
	if event.is_action_pressed('ui_left'):
		rotate_from(map_pos , -PI/2.0)
		new_pivot_pos(Vector2i(Vector2(map_pos + Vector2i(1,0)).rotated(-PI/2.0).round()), -PI/2.0)
		draw_indicator()
	
	if event.is_action_pressed('ui_right'):
		rotate_from(map_pos , PI/2.0)
		new_pivot_pos(Vector2i(Vector2(map_pos + Vector2i(1,0)).rotated(PI/2.0).round()), PI/2.0)
		draw_indicator()


func draw_indicator():
	for old_indicator in $Indicator.get_children():
		old_indicator.queue_free()
		
	for shape_pos in shape:
		var indicator = Indicator.instantiate()
		$Indicator.add_child(indicator)
		print(str(shape_pos) + " => " + str(map.map_to_world(Vector2i(shape_pos) + Vector2i(map_pos))))
		indicator.global_position = map.map_to_world(Vector2i(shape_pos) + Vector2i(map_pos))
