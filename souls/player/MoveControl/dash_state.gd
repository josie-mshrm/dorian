class_name DashState
extends MoveState

var dash_velocity : Vector3

func _setup() -> void:
	reset_dash_values()


func _enter() -> void:
	dash()


func _exit() -> void:
	soul.velocity -= dash_velocity


func dash():
	reset_dash_values()
	dash_velocity = dash_velocity.rotated(Vector3.UP, control.player_camera.rotation.y)
	soul.velocity += dash_velocity
	
	await get_tree().create_timer(soul.dash_time).timeout
	dispatch(&"idle")


func reset_dash_values():
	dash_velocity.z = -soul.dash_distance / soul.dash_time
	dash_velocity.x = 0
