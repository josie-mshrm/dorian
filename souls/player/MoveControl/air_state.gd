class_name AirState
extends MoveState


func _update(_delta: float) -> void:
	if soul.is_on_floor():
		dispatch(&"landing")
