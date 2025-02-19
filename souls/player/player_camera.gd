class_name PlayerCamera
extends Node3D

var camera_input : Vector3
var camera_rotation_sensitivity := 0.05
var mouse_rotation_sensitvity := 0.05
var rotation_limit_vertical := deg_to_rad(75)

@onready var spring_arm: SpringArm3D = $SpringArm
@onready var camera: Camera3D = $SpringArm/Camera3D


func _physics_process(_delta: float) -> void:
	camera_input = InputController.camera_movement
	
	# vertical camera rotation
	rotation.x += camera_input.z * camera_rotation_sensitivity
	if InputController.mouse_camera:
		rotation.x -= InputController.mouse_camera_movement.y * camera_rotation_sensitivity * mouse_rotation_sensitvity
	
	rotation.x = clampf(rotation.x, -rotation_limit_vertical, rotation_limit_vertical * 0.25)
	
	# horizontal camera rotation
	rotation.y += camera_input.x * camera_rotation_sensitivity
	if InputController.mouse_camera:
		rotation.y -= InputController.mouse_camera_movement.x * camera_rotation_sensitivity * mouse_rotation_sensitvity
		InputController.mouse_camera_movement = Vector2.ZERO
