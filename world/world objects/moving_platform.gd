@tool
class_name MovingPlatform
extends Platform

@export var size := Vector3.ZERO
@export var target := Vector3.ZERO
@export var trigger_position := Global.CornerPosition.TOP_LEFT
@export var move_time : float = 3.0
@export var wait_time : float = 3.0

var init_position : Vector3
var area_mesh : BoxMesh

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var target_node: MeshInstance3D = $Target
@onready var trigger_area: Area3D = $AreaTrigger
@onready var trigger_collision: CollisionShape3D = $AreaTrigger/CollisionShape3D
@onready var trigger_mesh : MeshInstance3D = $AreaTrigger/MeshInstance3D


func _enter_tree() -> void:
	request_ready()

func _ready() -> void:
	set_platform_size()

func move_platform():
	set_deferred(&"trigger_area.monitoring", false)
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, ^"position", target_node.global_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"position", init_position, move_time)
	await tween.finished
	set_deferred(&"trigger_area.monitoring", true)

func set_platform_size():
	init_position = global_position
	
	var shape := collision_shape_3d.shape
	if shape is BoxShape3D:
		shape.size = size
	
	var mesh := mesh_instance_3d.mesh
	if mesh is BoxMesh:
		mesh.size = size
	
	var area_shape = trigger_collision.shape
	if area_shape is BoxShape3D:
		area_shape.size = size / 4
		trigger_collision.position.y = size.y / 2
		
		trigger_mesh.position.y = trigger_collision.position.y
		if trigger_mesh.mesh is BoxMesh:
			area_mesh = trigger_mesh.mesh
			area_mesh.size = area_shape.size
			area_mesh.size.y = 1
		
		match trigger_position:
			Global.CornerPosition.TOP_LEFT:
				trigger_collision.position.x = (-size.x / 2) + (area_shape.size.x / 2)
				trigger_collision.position.z = (-size.z / 2) + (area_shape.size.z / 2)
			Global.CornerPosition.TOP_RIGHT:
				trigger_collision.position.x = (size.x / 2) - (area_shape.size.x / 2)
				trigger_collision.position.z = (-size.z / 2) + (area_shape.size.z / 2)
			Global.CornerPosition.BOTTOM_LEFT:
				trigger_collision.position.x = (-size.x / 2) + (area_shape.size.x / 2)
				trigger_collision.position.z = (size.z / 2) - (area_shape.size.z / 2)
			Global.CornerPosition.BOTTOM_RIGHT:
				trigger_collision.position.x = (size.x / 2) - (area_shape.size.x / 2)
				trigger_collision.position.z = (size.z / 2) - (area_shape.size.z / 2)
			Global.CornerPosition.CENTER:
				trigger_collision.position.x = 0
				trigger_collision.position.z = 0
	
	var target_mesh := target_node.mesh
	if target_mesh is BoxMesh:
		target_mesh.size = size / 4
	target_node.position = target
	
	if Engine.is_editor_hint():
		target_node.show()
	else:
		target_node.hide()


func _on_area_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		move_platform()
		trigger_mesh.hide()
		await get_tree().create_timer(0.5).timeout
		trigger_mesh.show()
