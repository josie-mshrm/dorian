class_name IdleState
extends MoveState

func _enter() -> void:
	print("idle")

func _update(delta: float) -> void:
	if soul.velocity > Vector3.ZERO:
		dispatch(&"run")
