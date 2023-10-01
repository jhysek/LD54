extends Node2D

signal jumped

const JUMP_DURATION = 0.2

var Indicator = load("res://Components/GameObjects/Indicator/indicator.tscn")

@export var map: TileMap
@export var turtle_controls = true

var moving = false
var map_pos = Vector2i(0,0)
var direction = Vector2i.UP
var attached_object = null
var draggable = null

var shape = [
	Vector2i(0,0)
]

func _ready():
	map_pos = map.world_to_map(position)
	calc_zindex(map_pos)
	position = map.map_to_world(map_pos)
	set_process_input(true)
	draw_indicator()
	draw_direction()

func _input(event):		
	var v2dir = Vector2(direction)
	
	if turtle_controls:			
		if event.is_action_pressed('ui_left'):
			rotate_to(-PI/2.0)
		
		if event.is_action_pressed('ui_right'):
			rotate_to(PI/2.0)
		
		if event.is_action_pressed('ui_up'):
			move_to(map_pos + direction)
		
		if event.is_action_pressed('ui_down'):
			move_to(map_pos - direction)
	else:
		if event.is_action_pressed('ui_left'):
			if direction == Vector2i.LEFT:
				move_to(map_pos + direction)
			else:
				rotate_to(v2dir.angle_to(Vector2.LEFT))
			
		if event.is_action_pressed('ui_right'):
			if direction == Vector2i.RIGHT:
				move_to(map_pos + direction)
			else:
				rotate_to(v2dir.angle_to(Vector2.RIGHT))
			
		if event.is_action_pressed('ui_up'):
			if direction == Vector2i.UP:
				move_to(map_pos + direction)
			else:
				rotate_to(v2dir.angle_to(Vector2.UP))
			
		if event.is_action_pressed('ui_down'):
			if direction == Vector2i.DOWN:
				move_to(map_pos + direction)
			else:
				rotate_to(v2dir.angle_to(Vector2.DOWN))
	
	if event.is_action_pressed('ui_accept'):
		if attached_object:
			drop()
		else:
			if draggable != null:
				pick(draggable)
		
func pick(object):
	object.calc_zindex(map_pos + direction)
	if object.z_index < z_index:
		object.show_behind_parent = true
	
	attached_object = object
	attached_object.pick(map_pos + direction)
	if object.z_index < z_index:
		object.show_behind_parent = true
	attach_shape(object)
	draw_indicator()
	$AnimationPlayer.play("Hold")
	draggable = null 
	
func drop():
	attached_object.drop(attachable_shape())
	
	var obj_positions = []
	for shape_pos in shape:
		if shape_pos != Vector2i(0,0):
			obj_positions.append(map.map_to_world(map_pos + shape_pos))
		
	attached_object.set_positions(obj_positions, 0)
	
	print("ATTACHABLE POS: " + str(attached_object.map_pos))
		
	
		
	attached_object = null 
	shape = [Vector2i(0,0)]
	$AnimationPlayer.play("Idle")
	draw_indicator()
	check_draggables()
	
func attachable_shape():
	print("PLAYER SHAPE: " + str(shape) + " player direction: " + str(direction) + "  pick offset: " + str(attached_object.pick_offset))
	var new_shape = []
	for shape_pos in shape:
		if shape_pos != Vector2i(0,0):
			new_shape.append(shape_pos - direction + attached_object.pick_offset)
	print("EXTRACTED SHAPE: " + str(new_shape))
	return new_shape
	
func attach_shape(object):
	for shape_pos in object.shape:
		var relative_pos = object.map_pos + shape_pos - map_pos
		shape.append(relative_pos) 
	
func draw_indicator():
	for old_indicator in $Indicator.get_children():
		old_indicator.queue_free()
		
	for shape_pos in shape:
		var indicator = Indicator.instantiate()
		$Indicator.add_child(indicator)
		indicator.global_position = map.map_to_world(shape_pos + map_pos)
		
func draw_direction():
	for child in $Visual/Direction.get_children():
		child.hide()

	$Visual/Back.hide()
	$Visual/Front.show()
		
	if direction == Vector2i.UP:
		$Visual/Direction/Up.show()
		$Visual/Back.scale.x = 1
		$Visual/Back.show()
		$Visual/Front.hide()
	if direction == Vector2i.DOWN:
		$Visual/Direction/Down.show()
		$Visual/Front.scale.x = 1
	if direction == Vector2i.LEFT:
		$Visual/Direction/Left.show()
		$Visual/Front.scale.x = -1
	if direction == Vector2i.RIGHT:
		$Visual/Direction/Right.show()
		$Visual/Front.scale.x = 1
		
func in_direction(jump_vector: Vector2i):
	return (jump_vector.y == 0 and direction.y == 0) \
		or (jump_vector.x == 0 and direction.x == 0)

func rotate_to(angle):
	var new_shape = []
	for shape_pos in shape:
		var new_vector = Vector2(shape_pos).rotated(angle)
		new_shape.append(Vector2i(new_vector.round()))
		
	if map.is_room_for(self, map_pos, new_shape):
		direction = Vector2i(Vector2(direction).rotated(angle))
		shape = new_shape
		draw_indicator()
		draw_direction()
		check_draggables()
		if attached_object != null:
			var obj_positions = []
			for shape_pos in shape:
				if shape_pos != Vector2i(0,0):
					obj_positions.append(map.map_to_world(map_pos + shape_pos))
			attached_object.set_positions(obj_positions, angle)
			attached_object.calc_zindex()
	else:
		print("NO ROOM FOR ROTATE")

func move_to(new_map_pos: Vector2i):
	if map.is_room_for(self, new_map_pos, shape):
		jump_to_map_pos(new_map_pos)
	else:
		print("NO ROOM FOR MOVE")
		
func jump_to_map_pos(new_map_pos: Vector2i):
	moving = true
	emit_signal("jumped")

	if attached_object:
		attached_object.tween_to(attached_object.map_pos + new_map_pos - map_pos)
		
	calc_zindex(new_map_pos)
	$AnimationPlayer.play("Jump")
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, 'position', map.map_to_world(new_map_pos), JUMP_DURATION)
	tween.tween_callback(func():
		map_pos = new_map_pos
		moving = false
		draggable = null
		if attached_object == null:
			check_draggables()
		else:
			var obj_positions = []
			for shape_pos in shape:
				if shape_pos != Vector2i(0,0):
					obj_positions.append(map.map_to_world(map_pos + shape_pos))
			attached_object.set_positions(obj_positions, 0)
			attached_object.calc_zindex())

func check_draggables():
	draggable = map.object_at(map_pos + direction)
	if draggable != null:
		print("OBJECT AHEAD: " + str(draggable.name))

func _on_animation_player_animation_finished(anim_name):
	if !attached_object and !anim_name == "Hold":
		$AnimationPlayer.play("Idle")

func calc_zindex(map_position = map_pos):
	z_index = -1 * (map_position.x * 20 - map_position.y * 2)
	print("PLAYER Z: " + str(z_index))
