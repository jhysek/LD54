extends TileMap

var offset = Vector2(0, -30)
		
func is_room_for(object, start_pos, shape):
	return is_room_for_shape(start_pos, shape) and !is_shape_blocked(object, start_pos, shape)
	
func is_room_for_shape(start_pos, shape):
	for shape_pos in shape:
		var map_pos = start_pos + shape_pos
		if get_cell_source_id(0, map_pos) < 0:
			return false
	return true
	
func object_at(map_pos):
	for child in get_children():
		if child.is_in_group('Blocker'):
			for shape_pos in child.shape:
				if child.map_pos + shape_pos == map_pos:
					return child
	return null
	
func is_shape_blocked(object, start_pos, shape):
	var blockers = get_blockers(object)
	var blocked = false
	for shape_pos in shape:
		var map_pos = start_pos + shape_pos
		if is_pos_blocked(blockers, map_pos):
			return true
	return false
	
func get_blockers(except):
	var blockers = {}
	for child in get_children():
		if child != except and child.is_in_group('Blocker'):
			for shape_pos in child.shape:
				blockers[child.map_pos + shape_pos] = true
	return blockers
	
func is_pos_blocked(blockers, map_pos):
	return blockers.has(map_pos)

func map_to_world(map_pos):
	return Vector2(map_to_local(map_pos) + offset)
	
func world_to_map(world_pos):
	return local_to_map(world_pos - offset)
