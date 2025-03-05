class_name Player
extends DynamicSoul


var last_known_ground : Vector3

@export var print_state : bool = false
@export var buffer_time : float = 0.5


@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var player_mesh: MeshInstance3D = $PlayerMesh


func _enter_tree() -> void:
	Global.player = self

func _ready() -> void:
	# init the movement state machine
	move_control.player = self
	move_control.set_active(true)
	
	move_control.active_state_changed.connect(on_state_changed)
	
	set_height()

func on_state_changed(new_state : LimboState, prev_state : LimboState):
	if print_state:
		if new_state != prev_state:
			print(new_state.name)
			#print("old state is " + prev_state.name)

func respawn():
	global_position = last_known_ground


func _process(_delta: float) -> void:
	rotate_player()


func rotate_player():
	if InputController.player_movement != Vector3.ZERO:
		var target_rotation := InputController.player_movement.normalized()
		target_rotation = target_rotation.rotated(Vector3.UP, player_camera.rotation.y)
		var target_quat = Quaternion(Vector3.FORWARD, target_rotation)
		
		player_mesh.quaternion = target_quat
