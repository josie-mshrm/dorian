class_name PlayerMoveControl
extends MoveControl

var target_velocity := Vector3.ZERO

@onready var player: Player = $".."
@onready var player_camera: PlayerCamera = $"../PlayerCamera"
@onready var rear_marker: Marker3D = $"../RearMarker"


func _ready() -> void:
	initialize(self)
	soul = player
	
	InputController.player_input.connect(on_player_input)
	
	set_raycasts()
	get_gravity()


func _setup() -> void:
	for child in get_children():
		if child is MoveState:
			child.soul = player
			child.control = self
			
			var child_name = child.name.trim_suffix("State") as StringName
			if not states.has(child_name):
				states[child_name] = child
	
	add_transition(ANYSTATE, states["Run"], &"run")
	add_transition(states["Run"], states["Idle"], &"idle")
	add_transition(ANYSTATE, states["Jump"], &"jump")
	add_transition(states["Jump"], states["Air"], &"air")
	add_transition(states["Run"], states["Air"], &"air")
	add_transition(ANYSTATE, states["Dash"], &"dash")
	
	add_transition(states["Dash"], states["Landing"], &"landing")
	add_transition(states["Air"], states["Landing"], &"landing")
	add_transition(states["Landing"], states["Idle"], &"idle")
	add_transition(states["Landing"], states["Run"], &"run")
	
	add_transition(states["Run"], states["Slide"], &"slide")
	add_transition(states["Idle"], states["Crouch"], &"crouch")
	add_transition(states["Slide"], states["Run"], &"run")


func _update(delta: float) -> void:
	directional_movement(delta)
	
	if is_grounded():
		ability_reset()
	
	player.move_and_slide()


func directional_movement(delta: float):
	# if the direction is held, accelerate
	if InputController.player_movement != Vector3.ZERO:
		target_velocity = InputController.player_movement.normalized()
		target_velocity *= player.speed # player speed is 12
		# if the input direction changes sign, set the player velocity directly to maximum
		
		# use the camera rotation to determine player direction
		target_velocity = target_velocity.rotated(Vector3.UP, player_camera.rotation.y)
		
		player.velocity.x = move_toward(player.velocity.x, target_velocity.x, player.speed * player.accel_rate * delta)
		player.velocity.z = move_toward(player.velocity.z, target_velocity.z, player.speed * player.accel_rate * delta)
		
		player.velocity.y -= gravity * delta
	# if no direction is held, decelerate
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.decel_rate * delta)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed * player.decel_rate * delta)
		
		player.velocity.y -= gravity * delta


func on_player_input(action: Global.Action, event: InputEvent):
	match action:
		Global.Action.JUMP:
			if jump_checker():
				soul.jump_counter += 1
				dispatch(&"jump")
			else:
				buffer_action(action, event)
		Global.Action.DASH:
			dispatch(&"dash")
		Global.Action.SLIDE:
			dispatch(&"slide")


func set_raycasts():
	ray_down = $"../RayDown"
	ray_left = $"../RayLeft"
	ray_right = $"../RayRight"
	ray_forward = $"../RayForward"
	ray_backward = $"../RayBackward"
