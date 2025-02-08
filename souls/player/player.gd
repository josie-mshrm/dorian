class_name Player
extends Soul

var speed := 10

@onready var player_move_control: PlayerMoveControl = $PlayerMoveControl

func _ready() -> void:
	# init the movement state machine
	player_move_control.player = self
	player_move_control.set_active(true)
