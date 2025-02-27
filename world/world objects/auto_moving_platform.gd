@tool
class_name AutoMovingPlatform
extends Platform

@export var size := Vector3.ZERO
@export var target := Vector3.ZERO
@export var move_time : float = 3.0
@export var wait_time : float = 3.0

var init_position : Vector3

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var target_node: MeshInstance3D = $Target

func _enter_tree() -> void:
	request_ready()

func _ready() -> void:
	init_position = global_position
	set_platform_size()
	
	if not Engine.is_editor_hint():
		move_platform()

func move_platform():
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	
	tween.tween_property(self, ^"position", target_node.global_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"position", init_position, move_time)
	tween.tween_interval(wait_time)

func set_platform_size():
	var shape := collision_shape_3d.shape
	if shape is BoxShape3D:
		shape.size = size
	
	var mesh := mesh_instance_3d.mesh
	if mesh is BoxMesh:
		mesh.size = size
	
	var target_mesh := target_node.mesh
	if target_mesh is BoxMesh:
		target_mesh.size = size / 4
	target_node.position = target
	
	if Engine.is_editor_hint():
		target_node.show()
	else:
		target_node.hide()
