## scrap script for quick moving platform
extends AnimatableBody3D

var tween : Tween
@onready var area_3d: Area3D = $Area3D

func run_animation():
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(5)
	tween.tween_property(self, ^":position:y", 64, 1.5)
	tween.tween_interval(2.0)
	tween.tween_property(self, ^":position:y", 0, 1.5)
	tween.tween_interval(2.0)
	tween.play()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Soul:
		run_animation()
		area_3d.call_deferred(&"set_monitoring", false)
		await tween.finished
		area_3d.call_deferred(&"set_monitoring", true)
