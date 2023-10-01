extends "res://Components/GameObjects/Sofa/sofa.gd"


func _init():
	super()
	shape = [
		Vector2i(0,0),
		Vector2i(1,0),
		Vector2i(1,1)
	]
	
	shape_size = Vector2(460, 400)


func drop(new_shape):
	print("OLD SHAPE: " + str(shape))
	super(new_shape)
	print("NEW SHAPE: " + str(shape))
	
	#draw_indicator()

func set_positions(positions, _angle = 0):
	global_position = positions[0] 
	map_pos = map.world_to_map(global_position)
	
	print(positions)
	
	pick_offset = Vector2i(Vector2(pick_offset).rotated(_angle).round())
	
	if positions[0].x > positions[1].x and positions[0].y > positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(1,-2)) / 2 - Vector2(0, 50)
		sprite_idx = 1
		
	if positions[0].x > positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(-1,-2)) / 2- Vector2(0, 50) 
		sprite_idx = 2
		
	if positions[0].x < positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(0, 1)) / 2- Vector2(0, 50) 
		sprite_idx = 3
		
	if positions[0].x < positions[1].x and positions[0].y > positions[1].y:
		$Visual.position = map.map_to_world(Vector2(2,-1)) / 2 - Vector2(0, 50)
		sprite_idx = 0
		
	set_region()
