class_name ComponentRoomCamera
extends Camera2D

@export var camera_speed: float = 15.0

var current_zone: ComponentRoomCameraZone
var follow_player: Player
var external_camera: Camera2D

var real_limit_left: float
var real_limit_right: float
var real_limit_top: float
var real_limit_bottom: float

var external_zoom: float:
	get():
		if external_camera:
			return external_camera.zoom.x
		else:
			return 0.0 

var goal_position: Vector2 = Vector2.ZERO

signal movement_enabled
var movement_is_enabled: bool = true:
	set(value): 
		if value != movement_is_enabled and value == true:
			movement_enabled.emit()
		movement_is_enabled = value

func _physics_process(delta: float) -> void:
	match Global.current_multiplayer_status:
		Utils.multiplayer_status.SINGLEPLAYER:
			_process_singleplayer(delta)
		Utils.multiplayer_status.LOCAL_MULTIPLAYER:
			_process_local_multiplayer(delta)
		Utils.multiplayer_status.ONLINE_MULTIPLAYER:
			pass # need to create
	
	_move(delta)

func _ready() -> void:
	_setup.call_deferred()
	Global.external_camera_updated.connect(_update_external_camera)

func _setup() -> void:
	_update_external_camera(Global.external_camera)
	Global.internal_camera = self

func _update_external_camera(_camera: ExternalCamera) -> void:
	external_camera = _camera

func Set_Limits(_left: float, _right: float, _top: float, _bottom: float) -> void:
	real_limit_left = _left
	real_limit_right = _right
	real_limit_top = _top
	real_limit_bottom = _bottom
	
	if !movement_is_enabled:
		await movement_enabled
	
	var _camera_size = Vector2(get_viewport().size)
	var _extra_size: Vector2 = _camera_size / 2 - _camera_size / external_zoom
	
	limit_left = _left - _extra_size.x
	limit_right = _right + _extra_size.x
	limit_top = _top - _extra_size.y
	limit_bottom = _bottom + _extra_size.y

func _process_singleplayer(delta: float) -> void: 
	var _player = Global.single_player_player
	if _player:
		goal_position = _player.global_position

func _process_local_multiplayer(delta: float) -> void:
	var _players = get_tree().get_nodes_in_group("Player")
	var _position := Vector2.ZERO
	var _i: int = 0
	
	var max_x: float = 0
	var min_x: float = INF
	
	var max_y: float = 0
	var min_y: float = INF
	
	for _player in _players:
		if _player is Player:
			var _pos = _player.global_position
			_position += _pos
			_i += 1
			if external_camera:
				if _pos.x > max_x: max_x = _pos.x
				if _pos.x < min_x: min_x = _pos.x
				if _pos.y < min_y: min_y = _pos.y
				if _pos.y > max_y: max_y = _pos.y
	
	if _i != 0:
		goal_position = _position
		
		var _dist_proc = Vector2(abs(max_x - min_x), abs(max_y - min_y)) / (get_viewport().size / external_zoom)
		var _max_dist = (1 - clamp(max(_dist_proc.x, _dist_proc.y), 1, 2)) * 2
		if _max_dist > 1:
			SignalBus.external_camera_property_change.emit({
				&"zoom": Vector2(_max_dist, _max_dist)
			})

func move_to_goal() -> void:
	position = goal_position

func _move(delta: float) -> void:
	if !movement_is_enabled:
		await movement_enabled
	position = lerp(position, goal_position, delta * camera_speed)
	
