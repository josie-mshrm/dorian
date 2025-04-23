class_name MovementPoint
extends Resource

signal VariableChanged

@export var target_position : Vector3:
	set(new_position):
		target_position = new_position
		VariableChanged.emit()
@export var movement_time : float:
	set(new_time):
		movement_time = new_time
		VariableChanged.emit()
@export var stop_at_point : bool:
	set(value):
		stop_at_point = value
		VariableChanged.emit()
@export var wait_time : float = 0.0:
	set(new_time):
		wait_time = new_time
		VariableChanged.emit()
