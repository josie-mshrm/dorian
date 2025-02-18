class_name PlayerMoveControl
extends LimboHSM

var target_velocity := Vector3.ZERO
var gravity : float
var default_gravity := 98.0

var states : Dictionary[StringName, MoveState] = {}

@onready var idle_state: LimboState = $IdleState
@onready var run_state: RunState = $RunState
@onready var player: Player = $".."
@onready var player_camera: PlayerCamera = $"../PlayerCamera"

func _ready() -> void:
	initialize(self)
	
	InputController.player_input.connect(on_player_input)
	
	get_gravity()

func _setup() -> void:
	for child in get_children():
		if child is MoveState:
			child.soul = player
			child.control = self
			
			var child_name = child.name.trim_suffix("State") as StringName
			if not states.has(child_name):
				states[child_name] = child
	
	add_transition(states["Idle"], states["Run"], &"run")
	add_transition(states["Run"], states["Idle"], &"idle")
	add_transition(ANYSTATE, states["Jump"], &"jump")
	add_transition(states["Jump"], states["Idle"], &"idle")
	add_transition(ANYSTATE, states["Dash"], &"dash")
	add_transition(states["Dash"], states["Idle"], &"idle")


func _update(delta: float) -> void:
	directional_movement(delta)
	
	
	player.move_and_slide()


func directional_movement(delta: float):
	target_velocity = InputController.player_movement.normalized()
	target_velocity *= player.speed
	# use the camera rotation to determine player direction
	target_velocity = target_velocity.rotated(Vector3.UP, player_camera.rotation.y)
	
	# TODO use move_towards() function to add accel
	player.velocity.x = move_toward(player.velocity.x, target_velocity.x, 2.5)
	player.velocity.z = move_toward(player.velocity.z, target_velocity.z, 2.5)
	#player.velocity.x = target_velocity.x
	#player.velocity.z = target_velocity.z
	
	player.velocity.y -= gravity * delta


func on_player_input(action: Global.Action, _event: InputEvent):
	match action:
		Global.Action.JUMP:
			dispatch(&"jump")
		Global.Action.DASH:
			dispatch(&"dash")

func get_gravity():
	if "Jump" in states:
		gravity = states["Jump"].fall_gravity
	else:
		gravity = default_gravity
