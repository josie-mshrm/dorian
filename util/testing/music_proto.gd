class_name MusicProto
extends Node

signal BeatEvent(bar: BarNumber)

var bar:= BarNumber.new()

func _ready() -> void:
	bar.Bar = 1
	bar.Beat = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		BeatEvent.emit(bar)
