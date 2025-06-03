@tool
class_name Platform_v1
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
var indicator_box_mesh : BoxMesh
var tween : Tween
var init_position : Vector3

@export var collision_shape_3d: CollisionShape3D
@onready var box_shape : BoxShape3D = $CollisionShape3D.shape
@export var mesh_instance_3d: MeshInstance3D
@onready var box_mesh : BoxMesh = $MeshInstance3D.mesh

func _ready() -> void:
	if not VariableChanged.is_connected(on_stats_changed):
		VariableChanged.connect(on_stats_changed)
	
	if not Engine.is_editor_hint():
		init_position = self.global_position
		target_position = init_position + target_position
	
	if not Engine.is_editor_hint():
		match trigger_type:
			TriggerType.AUTO:
				move_platform()
	
	VariableChanged.emit()

func move_platform():
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if trigger_type == TriggerType.AUTO:
		tween.set_loops()
	
	tween.tween_property(self, ^"global_position", target_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"global_position", init_position, move_time)
	tween.tween_interval(wait_time)

func on_stats_changed():
	update_shape()

func update_shape():
	# Update the Collision Shape size
	box_shape.size = size
	# Update the mesh instance size
	box_mesh.size = size
	
	# While in the editor
	if Engine.is_editor_hint():
		# If the indicator_mesh doesn't exist, create it
		if indicator_mesh:
			indicator_mesh.position = target_position
			indicator_box_mesh.size = size
		else:
			make_target_indicator()
	# If not in the editor
	else:
		# Get rid of the indicator
		if indicator_mesh:
			indicator_mesh.queue_free()

func make_target_indicator():
	indicator_mesh = MeshInstance3D.new()
	indicator_box_mesh = BoxMesh.new()
	indicator_box_mesh.material = load("res://world/Basic Materials/indicator_material.tres")
	indicator_mesh.mesh = indicator_box_mesh
	add_child(indicator_mesh)
	update_shape()
