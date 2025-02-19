class_name AirState
extends MoveState


func _update(delta: float) -> void:
	if soul.is_on_floor():
		dispatch(&"run")
