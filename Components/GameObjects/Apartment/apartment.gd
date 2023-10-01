extends TileMap

var offset = Vector2(0, -30)

func _ready():
	$ObstacleIndicator.self_modulate = Color('ffffff', 0)
	
func show_obstacle_at(map_pos):		
	$ObstacleIndicator.position = map_to_world(map_pos)
	$ObstacleIndicator.self_modulate = Color('ffffff', 1)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($ObstacleIndicator, 'self_modulate', Color('ffffff', 0), 1)
		
func is_room_for(object, start_pos, shape):
	return is_room_for_shape(start_pos, shape) and !is_shape_blocked(object, start_pos, shape)
	
func can_rotate(object, target_shape, angle):	
	var blockers = get_blockers(object)
	var target_pos = object.map_pos + Vector2i(Vector2(object.direction).rotated(angle / 2).round())
	var blocked = is_pos_blocked(blockers, target_pos) or !is_room_for_shape(target_pos, [Vector2i(0,0)])
	if blocked:
		show_obstacle_at(target_pos)
		return false
		
	# ma shape diretion * 2?
	for shape_pos in object.shape:
		if shape_pos == object.direction * 2:
			print("ANO MA SHAPE")
			var second_target_pos = object.map_pos + Vector2i(Vector2(object.direction * 2).rotated(angle / 3).round())
			if (is_pos_blocked(blockers, second_target_pos) or !is_room_for_shape(second_target_pos, [Vector2i(0,0)])):
				show_obstacle_at(second_target_pos)
				return false
			var third_target_pos = object.map_pos + Vector2i(Vector2(object.direction * 2).rotated(angle / 3 * 2).round())
			if (is_pos_blocked(blockers, third_target_pos) or !is_room_for_shape(third_target_pos, [Vector2i(0,0)])):
				show_obstacle_at(third_target_pos)
				return false
	
	print("??? shape: " + str(object.shape))
	return true
	#return true
	# Check for 1 ahead
	#if direction == Vector2i.RIGHT:
	#	if is_room_for(object, start_pos, [Vector2i(1,1)])
	
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
