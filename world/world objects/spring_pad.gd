class_name SpringPad
extends Area3D
## This object should make any soul that enters it's area launch in the direction of it's normal with a defined velocity

@export var launch_magnitude : int = 60

var launch_vector : Vector3

@onready var up_launch: Node3D = $UpLaunch


func _ready() -> void:
	launch_vector = up_launch.global_position - global_position


func _on_body_entered(soul: Soul) -> void:
	if soul is DynamicSoul:
		soul.velocity = launch_vector * launch_magnitude
