class_name PlayerMoveControl
extends LimboHSM

var target_velocity := Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var idle_state: LimboState = $IdleState
@onready var run_state: RunState = $RunState
@onready var player: Player = $".."
@onready var player_camera: PlayerCamera = $"../PlayerCamera"

func _ready() -> void:
	initialize(self)

func _setup() -> void:
	for child in get_children():
		if child is MoveState:
			child.soul = player
			child.control = self
	
	add_transition(idle_state, run_state, &"run")
	add_transition(run_state, idle_state, &"idle")

func _update(delta: float) -> void:
	directional_movement(delta)
	
	player.move_and_slide()


func directional_movement(delta: float):
	target_velocity = InputController.player_movement.normalized()
	target_velocity *= player.speed
	# use the camera rotation to determine player direction
	target_velocity = target_velocity.rotated(Vector3.UP, player_camera.rotation.y)
	
	player.velocity.x = target_velocity.x
	player.velocity.z = target_velocity.z
	
	player.velocity.y -= gravity * delta
