@tool
class_name MovingPlatform
extends Platform

@export var auto_run := false
@export var trigger_on_area := false
@export var size := Vector3.ZERO
@export var target := Vector3.ZERO
@export var trigger_position := Global.CornerPosition.TOP_LEFT
@export var move_time : float = 3.0
@export var wait_time : float = 3.0

var init_position : Vector3
var tween : Tween = null
var trigger: Area3D = null
var trigger_collision: CollisionShape3D
var trigger_mesh : MeshInstance3D

@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var target_node: MeshInstance3D = $Target


func _enter_tree() -> void:
	request_ready()


func _ready() -> void:
	init_position = global_position
	
	set_platform_size()
	if trigger_on_area:
		create_trigger_area()
	if auto_run:
		move_platform()

func move_platform():
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, ^"position", target_node.global_position, move_time)
	tween.tween_interval(wait_time)
	tween.tween_property(self, ^"position", init_position, move_time)


func set_platform_size():
	if shape.shape is BoxShape3D:
		shape.shape.size = size
	
	if mesh.mesh is BoxMesh:
		mesh.mesh.size = size
	
	if target_node.mesh is BoxMesh:
		target_node.mesh.size = size / 4
	target_node.position = target
	
	if Engine.is_editor_hint():
		target_node.show()
	else:
		target_node.hide()


func _on_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		move_platform()
		
		if trigger_on_area:
			trigger_mesh.hide()
			trigger.set_deferred(&"monitoring", false)
			await get_tree().create_timer(0.5).timeout
			trigger_mesh.show()
			await tween.finished
			trigger.set_deferred(&"monitoring", true)


func create_trigger_area():
	if trigger:
		set_trigger_area_size()
		return
	else:
		trigger = Area3D.new()
		add_child(trigger)
		trigger.name = &"TriggerArea"
		
		trigger_collision = CollisionShape3D.new()
		trigger_collision.shape = BoxShape3D.new()
		trigger.add_child(trigger_collision)
		
		trigger_mesh = MeshInstance3D.new()
		trigger_mesh.mesh = BoxMesh.new()
		trigger.add_child(trigger_mesh)
		
		trigger.owner = self
		trigger_mesh.owner = trigger
		trigger_collision.owner = trigger
		trigger.body_entered.connect(_on_trigger_body_entered)
		
		set_trigger_area_size()


func set_trigger_area_size():
	## Code for setting the size and position of area trigger
	trigger.collision_mask = collision_mask
	trigger.position.y = size.y / 2
	
	if trigger_collision.shape is BoxShape3D:
		trigger_collision.shape.size = size / 4
	
	if trigger_mesh.mesh is BoxMesh:
		trigger_mesh.mesh.size = size / 4
	
	match trigger_position:
		Global.CornerPosition.TOP_LEFT:
			trigger_collision.position.x = (-size.x / 2) + (trigger_collision.shape.size.x / 2)
			trigger_collision.position.z = (-size.z / 2) + (trigger_collision.shape.size.z / 2)
		Global.CornerPosition.TOP_RIGHT:
			trigger_collision.position.x = (size.x / 2) - (trigger_collision.shape.size.x / 2)
			trigger_collision.position.z = (-size.z / 2) + (trigger_collision.shape.size.z / 2)
		Global.CornerPosition.BOTTOM_LEFT:
			trigger_collision.position.x = (-size.x / 2) + (trigger_collision.shape.size.x / 2)
			trigger_collision.position.z = (size.z / 2) - (trigger_collision.shape.size.z / 2)
		Global.CornerPosition.BOTTOM_RIGHT:
			trigger_collision.position.x = (size.x / 2) - (trigger_collision.shape.size.x / 2)
			trigger_collision.position.z = (size.z / 2) - (trigger_collision.shape.size.z / 2)
		Global.CornerPosition.CENTER:
			trigger_collision.position.x = 0
			trigger_collision.position.z = 0
