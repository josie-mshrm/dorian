class_name JumpState
extends MoveState

var jump_velocity
var jump_gravity
var fall_gravity


func _setup() -> void:
	calc_jump_var()


func _enter() -> void:
	jump()


func jump():
	control.gravity = jump_gravity
	soul.velocity.y += jump_velocity
	
	await get_tree().create_timer(soul.jump_peak_time).timeout
	control.gravity = fall_gravity


func _update(_delta: float) -> void:
	if soul.is_on_floor():
		dispatch(&"idle")


func calc_jump_var():
	jump_velocity = ((2.0 * soul.jump_height) / soul.jump_peak_time)
	jump_gravity = ((-2.0 * soul.jump_height) / (soul.jump_peak_time * soul.jump_peak_time)) * -1
	fall_gravity = ((-2.0 * soul.jump_height) / (soul.jump_fall_time * soul.jump_fall_time)) * -1
