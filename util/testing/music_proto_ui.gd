extends Control

@export var light_color : Color = Color(0.526, 0.712, 0.624)
@export var dark_color : Color = Color(0.112, 0.189, 0.154)

## Stores the box children of this node
var box: Array[ColorRect]
## The index of the current lit panel
var light_index: int

@onready var music_proto: MusicProto = $".."
@onready var rect_list: HBoxContainer = $RectList

func _ready() -> void:
	music_proto.BeatEvent.connect(on_beat_event)
	
	## Build the box array
	for i in rect_list.get_child_count():
		var child = rect_list.get_child(i)
		if child is ColorRect:
			box.insert(i, child)
	
	## Reset the variables
	light_index = -1 # -1 to avoid lighting any tiles
	move_indicator(box)


func on_beat_event(bar: BarNumber):
	if light_index < (box.size() - 1):
		light_index += 1
	else:
		light_index = 0
	
	move_indicator(box)

## Increases the current light index and reapplies the colors.
func move_indicator(box: Array[ColorRect]):
	for item in box:
		var i = box.find(item)
		if i != light_index:
			item.color = dark_color
		else:
			item.color = light_color
