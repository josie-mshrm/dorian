class_name PlayerSpawn
extends Area3D

func _ready() -> void:
	body_entered.connect(on_player_enter)


func on_player_enter(body : Soul):
	if body is Player:
		body.respawn_point = global_position
