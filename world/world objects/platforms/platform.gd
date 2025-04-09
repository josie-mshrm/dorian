@tool
class_name Platform
extends AnimatableBody3D

signal VariableChanged

enum PlatformType {STATIC, MOVING, DISAPPEARING, FALLING, ROTATING}
enum TriggerType {AUTO, BUTTON, CONTACT, SWITCH}


@export var size := Vector3.ONE:
	set(new_size):
		size = new_size
		VariableChanged.emit()

@export var target_position : Vector3:
	set(new_pos):
		target_position = new_pos
		VariableChanged.emit()


@export var wait_time := 3.0
@export var move_time := 3.0
@export var type : PlatformType
@export var trigger_type : TriggerType

var indicator_mesh : MeshInstance3D
var box_mesh : BoxMesh
var tween : Tween
var init_position : Vector3

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var box_shape : BoxShape3D = $CollisionShape3D.shape
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if not VariableChanged.is_connected(on_stats_changed):
		VariableChanged.connect(on_stats_changed)
	
	match type:
		PlatformType.STATIC:
			pass
		PlatformType.MOVING:
			pass
		PlatformType.DISAPPEARING:
			pass
		PlatformType.FALLING:
			pass
		PlatformType.ROTATING:
			pass
	
	match trigger_type:
		TriggerType.AUTO:
			pass
		TriggerType.BUTTON:
			pass
		TriggerType.CONTACT:
			pass
		TriggerType.SWITCH:
			pass

func move_platform():
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if type == TriggerType.AUTO:
		tween.set_loops()
	
	tween.tween_property(self, ^"position", target_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"position", init_position, move_time)
	tween.tween_interval(wait_time)

func on_stats_changed():
	update_shape()

func update_shape():
	box_shape.size = size
	if target_position != Vector3.ZERO and type == PlatformType.MOVING:
		if indicator_mesh and Engine.is_editor_hint():
			indicator_mesh.position = target_position
			box_mesh.size = size
		elif not indicator_mesh and Engine.is_editor_hint():
			make_target_indicator()
		elif indicator_mesh and not Engine.is_editor_hint():
			indicator_mesh.queue_free()
	elif target_position == Vector3.ZERO and indicator_mesh:
		indicator_mesh.queue_free()

func make_target_indicator():
	if target_position != Vector3.ZERO:
		indicator_mesh = MeshInstance3D.new()
		box_mesh = BoxMesh.new()
		box_mesh.material = load("res://world/Basic Materials/indicator_material.tres")
		indicator_mesh.mesh = box_mesh
		add_child(indicator_mesh)
		update_shape()


func _exit_tree() -> void:
	if indicator_mesh:
		indicator_mesh.queue_free()
