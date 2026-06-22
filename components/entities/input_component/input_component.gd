class_name InputComponent
extends Node

@export var entity: CharacterBody2D

signal Jump(is_pressed: bool)
signal Attack(is_pressed: bool)
signal Ability(is_pressed: bool, ability_name: StringName)

var abilities: Array[StringName] = []
var movement_direction: Vector2 = Vector2.ZERO

func Get_Movement_Direction() -> Vector2:
	return movement_direction
