class_name MoveControl
extends LimboHSM

var soul : DynamicSoul

var gravity : float
var default_gravity := 98.0

var states : Dictionary[StringName, MoveState] = {}
var action_buffer : Dictionary[Global.Action, InputEvent]

## Raycasts
@onready var ray_down: RayCast3D
@onready var ray_left: RayCast3D
@onready var ray_right: RayCast3D
@onready var ray_forward: RayCast3D
@onready var ray_backward: RayCast3D


func jump_checker() -> bool:
	if soul.jump_counter < soul.jump_count:
		return true
	return false


func get_gravity():
	if "Jump" in states:
		gravity = states["Jump"].fall_gravity
	else:
		gravity = default_gravity


func buffer_action(action: Global.Action, event: InputEvent):
	action_buffer.set(action, event)
	await get_tree().create_timer(soul.buffer_time).timeout
	action_buffer.erase(action)

## Checks the buffer for a specific action type, returns the input event if
## that action exists in the buffer
func check_action_buffer():
	if not action_buffer.is_empty():
		return true
	return false


func ability_reset():
	soul.jump_counter = 0


func is_against_wall():
	if ray_left.is_colliding()\
	or ray_right.is_colliding()\
	or ray_forward.is_colliding()\
	or ray_backward.is_colliding():
		return true
	return false


func is_grounded() -> bool:
	if ray_down.is_colliding():
		return true
	return false
