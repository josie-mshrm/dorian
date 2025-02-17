class_name RunState
extends MoveState

func _enter() -> void:
	#print("run")
	pass

func _update(_delta: float) -> void:
	if soul.velocity == Vector3.ZERO:
		dispatch(&"idle")
