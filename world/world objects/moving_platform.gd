@tool
class_name MovingPlatform
extends Platform

@export var size := Vector3i.ZERO
@export var target := Vector3i.ZERO
@export var trigger_position := Global.CornerPosition.TOP_LEFT
@export var move_time : float = 3.0
@export var wait_time : float = 3.0

var init_position : Vector3
var area_mesh : BoxMesh

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var target_node: MeshInstance3D = $Target
@onready var area_trigger: CollisionShape3D = $AreaTrigger/CollisionShape3D
@onready var area_indicator : MeshInstance3D = $AreaTrigger/MeshInstance3D


func _enter_tree() -> void:
	request_ready()

func _ready() -> void:
	set_platform_size()

func move_platform():
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, ^"position", target_node.global_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"position", init_position, move_time)
	

func set_platform_size():
	init_position = global_position
	
	var shape := collision_shape_3d.shape
	if shape is BoxShape3D:
		shape.size = size
	
	var mesh := mesh_instance_3d.mesh
	if mesh is BoxMesh:
		mesh.size = size
	
	var area_shape = area_trigger.shape
	if area_shape is BoxShape3D:
		area_shape.size = size / 4
		area_trigger.position.y = size.y / 1.75
		
		area_indicator.position.y = area_trigger.position.y
		if area_indicator.mesh is BoxMesh:
			area_mesh = area_indicator.mesh
			area_mesh.size = area_shape.size
			area_mesh.size.y = 1
		
		match trigger_position:
			Global.CornerPosition.TOP_LEFT:
				area_trigger.position.x = (-size.x / 2) + (area_shape.size.x / 2)
				area_trigger.position.z = (-size.z / 2) + (area_shape.size.z / 2)
			Global.CornerPosition.TOP_RIGHT:
				area_trigger.position.x = (size.x / 2) - (area_shape.size.x / 2)
				area_trigger.position.z = (-size.z / 2) + (area_shape.size.z / 2)
			Global.CornerPosition.BOTTOM_LEFT:
				area_trigger.position.x = (-size.x / 2) + (area_shape.size.x / 2)
				area_trigger.position.z = (size.z / 2) - (area_shape.size.z / 2)
			Global.CornerPosition.BOTTOM_RIGHT:
				area_trigger.position.x = (size.x / 2) - (area_shape.size.x / 2)
				area_trigger.position.z = (size.z / 2) - (area_shape.size.z / 2)
			Global.CornerPosition.CENTER:
				area_trigger.position.x = 0
				area_trigger.position.z = 0
	
	
	if Engine.is_editor_hint():
		var target_mesh := target_node.mesh
		if target_mesh is BoxMesh:
			target_mesh.size = size / 4
		target_node.position = target
		target_node.show()
	else:
		target_node.hide()


func _on_area_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		move_platform()
		area_indicator.position.y -= 0.5
		await get_tree().create_timer(0.5).timeout
		area_indicator.position.y += 0.5
