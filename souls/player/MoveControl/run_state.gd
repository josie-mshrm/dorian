class_name RunState
extends MoveState


func _update(_delta: float) -> void:
	if soul.velocity == Vector3.ZERO:
		dispatch(&"idle")
	
	if not control.is_grounded():
		dispatch(&"air")

func _exit() -> void:
	pass
