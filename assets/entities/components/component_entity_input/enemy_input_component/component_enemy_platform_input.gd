extends ComponentEntityInput
class_name EnemyPlatformComponentInput

@export var jump_raycasts: Array[RayCast2D]
@export var player_detection_area: Area2D

var current_target: CharacterBody2D
var jump_cooldown: Timer
var players_detected: Array[Player] = []

func _ready() -> void:
	jump_cooldown = Timer.new()
	add_child(jump_cooldown)
	jump_cooldown.one_shot = true
	jump_cooldown.autostart = false
	jump_cooldown.wait_time = 0.5
	
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
		movement_direction.x = sign(current_target.global_position.x - entity.global_position.x)
		
		var _should_jump := false
		for _ray in jump_raycasts:
			if _ray.is_colliding() and _ray.get_collider() is TileMapLayer:
				_should_jump = true
				break
		
		if _should_jump and jump_cooldown.is_stopped():
			Jump.emit(true)
			jump_cooldown.start()
	return movement_direction
