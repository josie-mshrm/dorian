extends Node

signal player_input()

var player_movement := Vector3.ZERO
var camera_movement := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	player_movement.x = Input.get_axis(&"left", &"right")
	player_movement.z = Input.get_axis(&"up", &"down")
	
	camera_movement.x = Input.get_axis("cam - left", "cam - right")
	camera_movement.z = Input.get_axis("cam - up", "cam - down")
	
