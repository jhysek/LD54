extends "res://Components/GameObjects/Sofa/sofa.gd"

func _init():
	super()
	shape_size = Vector2(306, 406)

func set_positions(positions, _angle = 0):
	global_position = positions[0] 
	map_pos = map.world_to_map(global_position)
	
	pick_offset = Vector2i(Vector2(pick_offset).rotated(_angle).round())
	
	if positions[0].x < positions[1].x and positions[0].y > positions[1].y: 
		$Visual.position = map.map_to_world(Vector2i(1,-1)) / 2 - Vector2(0, 90)
		sprite_idx = 3
		
	if positions[0].x > positions[1].x and positions[0].y > positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(0,-2)) / 2 - Vector2(0, 90)
		sprite_idx = 2
		
	if positions[0].x > positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2i(-1, -1)) / 2 - Vector2(0, 90)
		sprite_idx = 1
		
	if positions[0].x < positions[1].x and positions[0].y < positions[1].y:
		$Visual.position = map.map_to_world(Vector2(0,0)) / 2 - Vector2(0, 90)
		sprite_idx = 0
		
	set_region()
