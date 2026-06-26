extends ComponentEntityInput
class_name EnemyFlyingComponentEntityInput

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
		var _angle = entity.global_position.direction_to(current_target.global_position)
		movement_direction = _angle
	return movement_direction
