class_name ComponentLocalCameraMovement
extends Node

@export var local_camera: LocalCamera

@export var camera_speed: float = 15.0

# Un-adjusted limits of the camera
var real_limit_left: float
var real_limit_right: float
var real_limit_top: float
var real_limit_bottom: float

var goal_position: Vector2 = Vector2.ZERO # Position the camera is lerping towards

var movement_enabled_signals: Array[Signal] = []
var movement_is_enabled: bool = true:
	set(value): 
		if value != movement_is_enabled and value == true:
			movement_enabled.emit()
		movement_is_enabled = value
signal movement_enabled

func handle_physics(delta: float) -> void:
	# Various process functions
	match Global.current_multiplayer_status:
		Utils.multiplayer_status.SINGLEPLAYER:
			_process_singleplayer(delta)
		Utils.multiplayer_status.LOCAL_MULTIPLAYER:
			_process_local_multiplayer(delta)
		Utils.multiplayer_status.ONLINE_MULTIPLAYER:
			pass # need to create
	
	# Actual movement
	_move(delta)

#region Physics Functions
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
			if local_camera.external_camera:
				if _pos.x > max_x: max_x = _pos.x
				if _pos.x < min_x: min_x = _pos.x
				if _pos.y < min_y: min_y = _pos.y
				if _pos.y > max_y: max_y = _pos.y
	
	if _i != 0:
		goal_position = _position
		
		var _dist_proc = Vector2(abs(max_x - min_x), abs(max_y - min_y)) / (get_viewport().size / local_camera.external_zoom)
		var _max_dist = (1 - clamp(max(_dist_proc.x, _dist_proc.y), 1, 2)) * 2
		if _max_dist > 1:
			SignalBus.external_camera_property_change.emit({
				&"zoom": Vector2(_max_dist, _max_dist)
			})

# Actual movement to goal position
func _move(delta: float) -> void:
	if movement_is_enabled:
		local_camera.position = lerp(local_camera.position, goal_position, delta * camera_speed)
#endregion

func set_limits(_left: float, _right: float, _top: float, _bottom: float) -> void:
	real_limit_left = _left
	real_limit_right = _right
	real_limit_top = _top
	real_limit_bottom = _bottom
	
	var _camera_size = Vector2(get_viewport().size)
	var _extra_size: Vector2 = _camera_size / 2 - _camera_size / local_camera.external_zoom
	
	local_camera.limit_left = _left - _extra_size.x
	local_camera.limit_right = _right + _extra_size.x
	local_camera.limit_top = _top - _extra_size.y
	local_camera.limit_bottom = _bottom + _extra_size.y

func move_to_goal() -> void:
	print("CAMERA MOVED")
	local_camera.position = goal_position

func room_setup(_left: float, _right: float, _top: float, _bottom: float) -> void:
	if !movement_is_enabled:
		await movement_enabled
	
	set_limits(
		_left,
		_right,
		_top,
		_bottom
	)
	
	move_to_goal.call_deferred()

func enable_movement(transition: Utils.pixel_transition_types) -> void:
	movement_is_enabled = true
	print("CAMERA ENABLED")
	
	for _signal in movement_enabled_signals:
		if _signal.is_connected(enable_movement):
			_signal.disconnect(enable_movement)
	movement_enabled_signals.clear()

func connect_enable_movement(_signal: Signal) -> void:
	print("Enable connected!")
	if not _signal in movement_enabled_signals:
		movement_enabled_signals.append(_signal)
		_signal.connect(enable_movement)
	
