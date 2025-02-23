class_name Player
extends DynamicSoul


@export var print_state : bool = false
@export var buffer_time : float = 0.5

@onready var player_move_control: PlayerMoveControl = $PlayerMoveControl


func _ready() -> void:
	# init the movement state machine
	player_move_control.player = self
	player_move_control.set_active(true)
	
	player_move_control.active_state_changed.connect(on_state_changed)
	
	set_height()

func on_state_changed(new_state : LimboState, prev_state : LimboState):
	if print_state:
		if new_state != prev_state:
			print(new_state.name)
			#print("old state is " + prev_state.name)
