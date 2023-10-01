extends "res://Components/GameObjects/Furniture/furniture.gd"
var Indicator = load("res://Components/GameObjects/Indicator/indicator.tscn")

@export var DEBUG = false
var offsets = {}

func _init():
	shape = [
		Vector2i(0,0),
		Vector2i(0,1)
	]
	
	shape_size = Vector2(294, 248)
	super()

func pick(from_pos):
	super(from_pos)
	for old_indicator in $Indicator.get_children():
		old_indicator.queue_free()
	
func drop(new_shape):
	print("OLD SHAPE: " + str(shape))
	super(new_shape)
	print("NEW SHAPE: " + str(shape))
	
	draw_indicator()

func set_positions(positions, _angle = 0):
	global_position = positions[0] 
	map_pos = map.world_to_map(global_position)
	
	if positions[0].x < positions[1].x and positions[0].y > positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(1,-1)) / 2
		sprite_idx = 3
		
	if positions[0].x > positions[1].x and positions[0].y > positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(0,-2)) / 2
		sprite_idx = 2
		
	if positions[0].x > positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(-1, -1)) / 2
		sprite_idx = 1
		
	if positions[0].x < positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2(0,0)) / 2
		sprite_idx = 0
		
	set_region()
	

func draw_indicator():
	for old_indicator in $Indicator.get_children():
		old_indicator.queue_free()
		
	for shape_pos in shape:
		var indicator = Indicator.instantiate()
		indicator.modulate = Color('red')
		$Indicator.add_child(indicator)
		print(str(shape_pos) + " => " + str(map.map_to_world(Vector2i(shape_pos) + Vector2i(map_pos))))
		indicator.global_position = map.map_to_world(Vector2i(shape_pos) + Vector2i(map_pos))
