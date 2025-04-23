#@tool
class_name MovingPlatform
extends AnimatableBody3D

signal VariableChanged

@export var movement_points_array : Array[MovementPoint]
@export var constant_rate: bool = true
@export var size := Vector3.ONE:
	set(new_size):
		size = new_size
		VariableChanged.emit()

@export_group("Required Nodes")
@export var collision_node: CollisionShape3D
@export var mesh_node: MeshInstance3D

var indicator_mesh : MeshInstance3D
var indicator_box_mesh : BoxMesh
var init_position : Vector3

@onready var collision_shape : BoxShape3D = $CollisionShape3D.shape
@onready var mesh_shape : BoxMesh = $MeshInstance3D.mesh
@onready var path_node: Path3D = $Path3D
@onready var curve: Curve3D = $Path3D.curve

func _ready() -> void:
	if not VariableChanged.is_connected(on_stats_changed):
		VariableChanged.connect(on_stats_changed)
	
	# Iterate through the MovementPoints array and connect to the "VariableChanged" signal for each
	# When a new point is added, connect it's signal

func move_platform():
	pass
	# if constant rate
		# use the sample() function
	# else
		# go through each point in the array
		# get the move_time
		# increment the t value from 0 to 1 over the length of move_time


func on_stats_changed():
	update_shape()


func update_shape():
	# Update the Collision Shape size
	collision_shape.size = size
	# Update the mesh instance size
	mesh_shape.size = size
	
	# Update the Curve to contain the values of the MovementPoints array
	
	# If in the editor
		# Create the target indicator and set it's position to be the last point in the array


func make_target_indicator():
	indicator_mesh = MeshInstance3D.new()
	indicator_box_mesh = BoxMesh.new()
	indicator_box_mesh.material = load("res://world/Basic Materials/indicator_material.tres")
	indicator_mesh.mesh = indicator_box_mesh
	add_child(indicator_mesh)
	update_shape()


func _exit_tree() -> void:
	if indicator_mesh:
		indicator_mesh.queue_free()
	if VariableChanged.is_connected(on_stats_changed):
		VariableChanged.disconnect(on_stats_changed)
	# Iterate through the MovementPoints array and disconnect from the "VariableChanged" signal
