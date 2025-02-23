extends Node

signal player_input(action: Global.Action, event: InputEvent)

@export var mouse_camera := true

var player_movement := Vector3.ZERO
var camera_movement := Vector3.ZERO
var mouse_camera_movement := Vector2.ZERO


func _ready() -> void:
	if mouse_camera:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


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
	
	if event.is_action_pressed("slide"):
		player_input.emit(Global.Action.SLIDE, event)
	
	if mouse_camera:
		if event is InputEventMouseMotion:
			mouse_camera_movement = event.relative
