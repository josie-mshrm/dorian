class_name Player
extends Soul

var speed := 10
var target_velocity := Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	target_velocity = InputController.player_movement.normalized()
	target_velocity *= speed
	
	velocity = target_velocity
	move_and_slide()
