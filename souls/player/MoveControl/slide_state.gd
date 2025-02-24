class_name SlideState
extends MoveState

func _enter() -> void:
	slide()

func _exit() -> void:
	soul.soul_height *= 2
	soul.set_height()

func slide():
	soul.soul_height /= 2
	soul.set_height()
	await get_tree().create_timer(soul.slide_time).timeout
	dispatch(&"run")
