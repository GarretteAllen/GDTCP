extends CharacterBody2D

class_name Player

var target: Vector2 = Vector2()
var speed: float = 200
var is_moving : bool = false
var rotating = false
var last_mouse_pos = Vector2.ZERO
@onready var camera = $Camera2D


func _ready():
	if self.name == MpManager.local_player_id:
		camera.enabled = true
	else:
		camera.enabled = false
		
func spawn(saved_position: Vector2):
	position = saved_position
	target = saved_position
	print("Player spawned at:", saved_position)

func update_target(new_target: Vector2):
	target = new_target

func _input(event):
	if self.name == MpManager.local_player_id:
		if event.is_action_pressed("click"):
			target = get_global_mouse_position()
			update_target(target)
			is_moving = true
		if event.is_action_pressed("zoomIn"):
			camera.zoom += Vector2(0.1, 0.1)
			camera.zoom.x = clamp(camera.zoom.x, 0.2, 2)
			camera.zoom.y = clamp(camera.zoom.y, 0.2, 2)
		if event.is_action_pressed("zoomOut"):
			camera.zoom -= Vector2(0.1, 0.1)
			camera.zoom.x = clamp(camera.zoom.x, 0.2, 2)
			camera.zoom.y = clamp(camera.zoom.y, 0.2, 2)
		if event.is_action_pressed("rotate"):
			rotating = true
			last_mouse_pos = get_viewport().get_mouse_position()
		elif event.is_action_released("rotate"):
			rotating = false
		

func _physics_process(delta):
	if rotating:
		var current_mouse_pos = get_viewport().get_mouse_position()
		var mouse_delta = current_mouse_pos - last_mouse_pos
		var rotation_speed = 0.01
		
		camera.rotation += mouse_delta.x * rotation_speed
		last_mouse_pos = current_mouse_pos
	
	var direction = global_position.direction_to(target)
	var velocity = direction * speed * delta
	
	if global_position.distance_to(target) > velocity.length():
		global_position += velocity
		move_and_slide()
		print(direction)
	else:
		global_position = target
	if self.name == MpManager.local_player_id and global_position != target:
		Messenger.send_movement_update(MpManager.local_player_id, global_position)
		
