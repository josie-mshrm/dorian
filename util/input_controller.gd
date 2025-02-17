extends Node

signal player_input(action: Global.Action, event: InputEvent)

var player_movement := Vector3.ZERO
var camera_movement := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	player_movement.x = Input.get_axis(&"left", &"right")
	player_movement.z = Input.get_axis(&"up", &"down")
	
	camera_movement.x = Input.get_axis("cam - left", "cam - right")
	camera_movement.z = Input.get_axis("cam - up", "cam - down")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("jump"):
		player_input.emit(Global.Action.JUMP, event)
