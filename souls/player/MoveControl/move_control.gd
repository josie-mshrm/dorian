class_name MoveControl
extends LimboHSM

var soul : DynamicSoul

var gravity : float
var default_gravity := 98.0

var states : Dictionary[StringName, MoveState] = {}
var action_buffer : Array[Global.Action]


func jump_checker() -> bool:
	if soul.jump_counter < soul.jump_count:
		return true
	return false


func get_gravity():
	if "Jump" in states:
		gravity = states["Jump"].fall_gravity
	else:
		gravity = default_gravity


func buffer_action(action: Global.Action):
	action_buffer.push_front(action)
	await get_tree().create_timer(soul.buffer_time).timeout
	action_buffer.erase(action)


func check_action_buffer():
	if not action_buffer.is_empty():
		return true
	return false


func ability_reset():
	soul.jump_counter = 0


func is_grounded() -> bool:
	if soul.is_on_floor():
		var current_state = get_leaf_state()
		if current_state.is_in_group(&"ground"):
			return true
	return false
