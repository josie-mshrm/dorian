class_name IdleState
extends MoveState

func _enter() -> void:
	#print("idle")
	pass

func _update(_delta: float) -> void:
	if soul.velocity != Vector3.ZERO:
		dispatch(&"run")
