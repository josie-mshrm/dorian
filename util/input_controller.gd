extends Node

signal player_input(action: Global.Action, event: InputEvent)

var player_movement := Vector3.ZERO
var camera_movement := Vector3.ZERO

func _physics_process(_delta: float) -> void:
	player_movement.x = Input.get_axis(&"left", &"right")
	player_movement.z = Input.get_axis(&"up", &"down")
	
	camera_movement.x = Input.get_axis("cam - right", "cam - left")
	camera_movement.z = Input.get_axis("cam - down", "cam - up")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		player_input.emit(Global.Action.JUMP, event)
	
	if event.is_action_pressed("dash"):
		player_input.emit(Global.Action.DASH, event)
