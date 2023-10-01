extends Node2D

var shape = [
	Vector2i(0,0)
]
var shape_size = Vector2(154, 216)
var direction = Vector2i.UP
var anchor_cell = 0
var map_pos = Vector2i(0,0)
var pick_offset = Vector2(0,0)  # how far from map_pos was this furniture picked up?

@export var map: TileMap
@export var sprite_idx = 0


func _ready():
	map_pos = map.world_to_map(position)
	position = map.map_to_world(map_pos)
	shape_size = $Visual.region_rect.size
	set_region()

func update_map_pos():
	map_pos = map.world_to_map(position)

func tween_lift():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Visual, 'offset', Vector2(0, -30), 0.3)
	
func tween_drop():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Visual, 'offset', Vector2(0, 0), 0.3)

func pick(from_pos):
	pick_offset = from_pos - map_pos
	tween_lift()
	
func drop(new_shape):
	shape = new_shape
	tween_drop()

#func new_pivot_pos(pivot_pos, angle):
#	map_pos = pivot_pos + pick_offset
#	global_position = map.map_to_world(map_pos)
#	
#	if angle > 0:
#		rotate_shape(Vector2i.RIGHT)
#		
#	if angle < 0:
#		rotate_shape(Vector2i.LEFT)

func set_positions(positions, angle = 0):
	global_position = positions[0] 
	map_pos = map.world_to_map(global_position)
	
	if angle > 0:
		rotate_shape(Vector2i.RIGHT)
		
	if angle < 0:
		rotate_shape(Vector2i.LEFT)

func rotate_shape(rotate_direction: Vector2i):
	if rotate_direction == Vector2i.RIGHT:
		sprite_idx = (sprite_idx + 1) % 4
		
	if rotate_direction == Vector2i.LEFT:
		sprite_idx = (sprite_idx - 1) % 4
		if sprite_idx < 0:
			sprite_idx = 3

	set_region()
	
func place_picture():
	pass

func set_region():
	$Visual.region_rect = Rect2(Vector2(shape_size.x * sprite_idx, 0), shape_size)

		
