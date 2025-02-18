class_name DashState
extends MoveState

var dash_velocity : Vector3
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
	dash_velocity = dash_velocity.rotated(Vector3.UP, control.player_camera.rotation.y)
	soul.velocity += dash_velocity
	
	await get_tree().create_timer(soul.dash_time).timeout
	
	if InputController.player_movement == Vector3.ZERO:
		if soul.is_on_floor():
			dispatch(&"idle")
		else:
			dispatch(&"run") # fall state
	else:
		dispatch(&"run")


func reset_dash_values():
	dash_velocity.z = (soul.dash_distance / soul.dash_time) * -1
	dash_velocity.x = 0
	dash_velocity.y = 0
