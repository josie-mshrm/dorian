extends AnimatableBody3D

@export var target : Vector3
@export var move_time : float = 2.0

func _ready() -> void:
	move_platform()

func move_platform():
	var tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property(self, ^"position", self.global_position + target, move_time)
	tween.tween_interval(move_time)
	tween.tween_property(self, ^"position", position, move_time)
	tween.tween_interval(move_time)
