extends ComponentEntityInput
class_name EnemyPlatformComponentInput

@export var jump_raycasts: Array[RayCast2D]
@export var jump_platform_raycasts: Array[RayCast2D]
@export var player_detection_area: Area2D

var current_target: CharacterBody2D
var jump_cooldown: Timer
var players_detected: Array[Player] = []

enum jump_types {WALL, PLATFORM, PLAYER}
var current_jump := {
	"jumping": false,
	"type": jump_types.WALL,
	"ray": null
}

func _ready() -> void:
	jump_cooldown = Timer.new()
	add_child(jump_cooldown)
	jump_cooldown.one_shot = true
	jump_cooldown.autostart = false
	jump_cooldown.wait_time = 0.2
	
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
		var _distance = current_target.global_position - entity.global_position
		movement_direction.x = sign(_distance.x)
		
		var _should_jump := false
		for _ray in jump_raycasts:
			if _ray.is_colliding() and _ray.get_collider() is TileMapLayer:
				_should_jump = true
				current_jump["type"] = jump_types.WALL
				current_jump["ray"] = _ray
				break
		
		if _distance.y < 0:
			for _ray in jump_platform_raycasts:
				if not _ray.is_colliding():
					_should_jump = true
					current_jump["type"] = jump_types.PLATFORM
					current_jump["ray"] = _ray
					break
		
		if abs(_distance.x) < 32 and current_target.velocity.y - entity.velocity.y < -16 and sign(current_target.velocity.x) != sign(entity.velocity.x):
			_should_jump = true
			current_jump["type"] = jump_types.PLAYER
		
		if _should_jump and jump_cooldown.is_stopped():
			Jump.emit(true)
			jump_cooldown.start()
			current_jump["jumping"] = true
		elif current_jump["jumping"] == true:
			var _should_stop = false
			var _ray: RayCast2D = current_jump["ray"]
			if current_jump["type"] == jump_types.PLAYER and current_target.velocity.y > 0:
				Jump.emit(false)
				current_jump["jumping"] = false
	return movement_direction
