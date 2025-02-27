class_name AirState
extends MoveState


func _enter() -> void:
	if soul is Player:
		soul.last_known_ground = soul.global_position

func _update(_delta: float) -> void:
	if soul.is_on_floor():
		dispatch(&"landing")
