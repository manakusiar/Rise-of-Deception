class_name InputComponent
extends Node

# What this needs to do:
# 1. Have the general function to export the movement direction.
# 2. Have support for the signal emitting.

signal Jump(is_pressed: bool)
signal Attack(is_pressed: bool)
signal Ability(is_pressed: bool)

var movement_direction: Vector2

func Get_Movement_Direction() -> Vector2:
	return movement_direction
