class_name JumpState
extends MoveState

var jump_velocity
var jump_gravity
var fall_gravity

var min_timer : Timer

func _setup() -> void:
	calc_jump_var()
	min_timer = add_min_timer_node(soul.minimum_jump_time)
	InputController.player_release.connect(on_jump_release)


func _enter() -> void:
	jump()
	min_timer.start()


func _exit() -> void:
	if min_timer.time_left != 0:
		await min_timer.timeout
	
	control.gravity = fall_gravity


func jump():
	control.gravity = jump_gravity
	soul.velocity.y += jump_velocity
	
	await get_tree()\
	.create_timer(soul.jump_peak_time, false, true, true).timeout
	
	dispatch(&"fall")


func on_jump_release(action: Global.Action, event: InputEvent):
	if self.is_active():
		if action == Global.Action.JUMP:
			if event.is_action("jump"):
				dispatch(&"fall")


func calc_jump_var():
	jump_velocity = ((2.0 * soul.jump_height) / soul.jump_peak_time)
	jump_gravity = ((-2.0 * soul.jump_height) / (soul.jump_peak_time * soul.jump_peak_time)) * -1
	fall_gravity = ((-2.0 * soul.jump_height) / (soul.jump_fall_time * soul.jump_fall_time)) * -1
