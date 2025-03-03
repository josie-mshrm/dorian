class_name AirState
extends MoveState


func _update(_delta: float) -> void:
	if control.is_grounded():
		dispatch(&"landing")
