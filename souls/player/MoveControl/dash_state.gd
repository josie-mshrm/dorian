class_name DashState
extends MoveState

var dash_velocity : float
var dash_vector : Vector3
var init_velocity : Vector3
var dash_delta : float

func _setup() -> void:
	reset_dash_values()


func _enter() -> void:
	soul.velocity.y = 0
	reset_dash_values()
	dash()


func _exit() -> void:
	soul.velocity.z = 0
	soul.velocity.x = 0


func dash():
	dash_vector = InputController.player_movement.normalized() * dash_velocity
	if dash_vector == Vector3.ZERO:
		dash_vector = Vector3.FORWARD * dash_velocity
	dash_vector = dash_vector.rotated(Vector3.UP, control.player_camera.rotation.y)
	soul.velocity += dash_vector
	
	await get_tree().create_timer(soul.dash_time).timeout
	
	dispatch(&"landing")


func reset_dash_values():
	dash_velocity = (soul.dash_distance / soul.dash_time)
	dash_vector = Vector3.ZERO
