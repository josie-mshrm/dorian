extends Node

signal player_input()

var player_movement := Vector3.ZERO

func _physics_process(delta: float) -> void:
	player_movement.x = Input.get_axis(&"left", &"right")
	player_movement.z = Input.get_axis(&"up", &"down")
