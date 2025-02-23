## The base class for living beings that are able to move freely
class_name DynamicSoul
extends Soul

## Character movement speed
@export var speed := 12
@export var soul_height : float = 1.5


@export_group("Jump")
## The height of the jump in meters?
@export var jump_height : int = 6
## The time from the start to the peak
@export var jump_peak_time : float = 0.45
## The time for the jump to hit the initial starting position from peak
@export var jump_fall_time : float = 0.35
@export var jump_count : int = 1
var jump_counter : int = 0
@export var landing_time : float = 0.15

@export_group("Dash")
## The distance for the dash in meters
@export var dash_distance : int = 35
## The time the dash takes in seconds
@export var dash_time : float = 0.3

@export_group("Slide")
@export var slide_time := 0.5


@onready var collision_shape: CapsuleShape3D = $CollisionShape3D.shape
@onready var mesh: CapsuleMesh = $MeshInstance3D.mesh


func set_height():
	collision_shape.height = soul_height
	mesh.height = soul_height
