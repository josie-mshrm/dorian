## The base class for living beings that are able to move freely
class_name DynamicSoul
extends Soul

var speed := 10

@export_group("Jump")
@export var jump_height : int = 6
@export var jump_peak_time : float = 0.45
@export var jump_fall_time : float = 0.35

@export_group("Dash")
@export var dash_distance : int = 5
@export var dash_speed : int = 5
