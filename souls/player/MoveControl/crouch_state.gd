class_name CrouchState
extends MoveState

func _enter() -> void:
	crouch()

func _exit() -> void:
	soul.soul_height *= 2
	soul.set_height()

func crouch():
	soul.soul_height /= 2
	soul.set_height()

func _update(delta: float) -> void:
	if Input.is_action_just_released("dash") and InputController.layer == 1:
		dispatch(&"idle")
