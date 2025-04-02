extends Control

@export var parent : Soul
@onready var progress_bar: ProgressBar = $ProgressBar

func _process(delta: float) -> void:
	progress_bar.value = parent.health
