class_name CameraZone
extends Area2D

@export var limit_left: int
@export var limit_right: int
@export var limit_top: int
@export var limit_bottom: int

@export_enum("free", "horizontal", "vertical", "locked") var camera_mode := "free"

@export var locked_position: Vector2

signal player_entered(player: Player)

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(body) -> void:
	if body is Player:
		player_entered.emit(body)
