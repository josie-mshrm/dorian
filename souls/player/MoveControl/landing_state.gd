class_name LandingState
extends MoveState

func _enter() -> void:
	set_next_state()

func set_next_state():
	if control.check_action_buffer():
		var event : InputEvent = control.action_buffer[Global.Action.JUMP]
		if event.is_pressed():
			dispatch(&"jump")
	else:
		await get_tree().create_timer(soul.landing_time).timeout
		if InputController.player_movement != Vector3.ZERO:
			dispatch(&"run")
		else:
			dispatch(&"idle")
