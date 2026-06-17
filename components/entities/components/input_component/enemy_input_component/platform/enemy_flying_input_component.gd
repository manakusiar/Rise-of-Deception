extends InputComponent
class_name EnemyFlyingInputComponent

@export var player_detection_area: Area2D

var current_target: CharacterBody2D
var players_detected: Array[Player] = []

func _ready() -> void:
	player_detection_area.body_entered.connect(player_detected)
	player_detection_area.body_exited.connect(player_left_range)

func player_detected(body: Node2D) -> void:
	if body is Player:
		current_target = body

func player_left_range(body: Node2D) -> void:
	if body is Player and current_target == body:
		current_target = null

func Get_Movement_Direction() -> Vector2:
	movement_direction = Vector2.ZERO
	if current_target:
		movement_direction -= (entity.global_position.normalized() + current_target.global_position.normalized())/2
	return movement_direction
