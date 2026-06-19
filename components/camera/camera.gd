extends Camera2D

@export var external_camera: Camera2D
@export var camera_speed: float = 15.0
@export var camera_zoom_proc: float = 0.5

func _process(delta: float) -> void:
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
		position = lerp(position, _position / _i, delta * camera_speed)
		
		if external_camera:
			var _dist_proc = Vector2(abs(max_x - min_x), abs(max_y - min_y)) / (get_viewport().size * camera_zoom_proc)
			var _max_dist = (1 - clamp(max(_dist_proc.x, _dist_proc.y), 1, 2)) * 2
			if _max_dist > 1:
				external_camera.zoom = external_camera.zoom.lerp(Vector2(_max_dist, _max_dist), delta * camera_speed)
		
