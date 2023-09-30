extends Node2D

var shape = [
	Vector2i(0,0)
]
var shape_size = Vector2(154, 216)
var direction = Vector2i.UP
var anchor_cell = 0
var map_pos = Vector2i(0,0)

@export var map: TileMap
@export var sprite_idx = 0

func _ready():
	map_pos = map.world_to_map(position)
	position = map.map_to_world(map_pos)
	
	shape_size = $Visual/Sprite.region_rect.size
	set_region()
	set_process_input(true)

func update_map_pos():
	map_pos = map.world_to_map(position)

func pick():
	$AnimationPlayer.play("Pick")
	
func drop():
	$AnimationPlayer.play_backwards("Pick")
	update_map_pos()

func _input(event):
	return
	
	if Input.is_action_just_pressed('ui_left'):
		rotate_shape(Vector2i.LEFT)
	if Input.is_action_just_pressed('ui_right'):
		rotate_shape(Vector2i.RIGHT)

func rotate_shape(rotate_direction: Vector2i):
	if rotate_direction == Vector2i.RIGHT:
		sprite_idx = (sprite_idx + 1) % 4
		
	if rotate_direction == Vector2i.LEFT:
		sprite_idx = (sprite_idx - 1) % 4
		if sprite_idx < 0:
			sprite_idx = 3

	set_region()

func set_region():
	var sprite = $Visual/Sprite
	print("SPRITE IDX: " + str(sprite_idx))
	print("REGION: " + str(Rect2i(Vector2i(shape_size.x * sprite_idx, 0), shape_size)))
	sprite.region_rect = Rect2(Vector2(shape_size.x * sprite_idx, 0), shape_size)
