class_name LandingState
extends MoveState

func _enter() -> void:
	if control.check_action_buffer():
		var action = control.action_buffer.pop_front()
		var state : String = Global.Action.find_key(action)
		state = state.to_lower()
		dispatch(StringName(state))
	else:
		set_next_state()

func set_next_state():
	await get_tree().create_timer(soul.landing_time).timeout
	if InputController.player_movement != Vector3.ZERO:
		dispatch(&"run")
	else:
		dispatch(&"idle")
