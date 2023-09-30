extends Node2D

var Indicator = load("res://Components/GameObjects/Indicator/indicator.tscn")

@export var map: TileMap

var moving = false
var map_pos = Vector2i(0,0)
var direction = Vector2i.UP
var attached_object = null
var draggable = null

var shape = [
	Vector2i(0,0)
	#Vector2i(0, -1),
	#Vector2i(0, -2),
	#Vector2i(1, -2)
]

func _ready():
	map_pos = map.world_to_map(position)
	position = map.map_to_world(map_pos)
	set_process_input(true)
	draw_indicator()
	draw_direction()

func _input(event):	
	if moving: 
		return
			
	if event.is_action_pressed('ui_left'):
		rotate_to(-PI/2.0)
		
	if event.is_action_pressed('ui_right'):
		rotate_to(PI/2.0)
		
	if event.is_action_pressed('ui_up'):
		move_to(map_pos + direction)
		
	if event.is_action_pressed('ui_down'):
		move_to(map_pos - direction)
		
	if event.is_action_pressed('ui_accept'):
		if attached_object:
			drop()
		else:
			if draggable != null:
				pick(draggable)
		
func pick(object):
	object.reparent($Attachment)
	attached_object = object
	attached_object.pick()
	draggable = null 
	
func drop():
	attached_object.reparent(get_parent())
	attached_object.drop()
	attached_object = null 
	check_draggables()
	
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
	
	if direction == Vector2i.UP:
		$Visual/Direction/Up.show()
	if direction == Vector2i.DOWN:
		$Visual/Direction/Down.show()
	if direction == Vector2i.LEFT:
		$Visual/Direction/Left.show()
	if direction == Vector2i.RIGHT:
		$Visual/Direction/Right.show()
		
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
	else:
		print("NO ROOM FOR ROTATE")

func move_to(new_map_pos: Vector2i):
	if map.is_room_for(self, new_map_pos, shape):
		jump_to_map_pos(new_map_pos)
	else:
		print("NO ROOM FOR MOVE")
		
func jump_to_map_pos(new_map_pos: Vector2i):
	moving = true
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, 'position', map.map_to_world(new_map_pos), 0.3)
	tween.tween_callback(func():
		map_pos = new_map_pos
		moving = false
		draggable = null
		if attached_object == null:
			check_draggables())
	
func check_draggables():
	draggable = map.object_at(map_pos + direction)
	if draggable != null:
		print("OBJECT AHEAD: " + str(draggable.name))
