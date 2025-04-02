class_name Soul
extends CharacterBody3D

## The base class for living entities
@export var health : int = 100

func damage(value : int):
	health -= value
