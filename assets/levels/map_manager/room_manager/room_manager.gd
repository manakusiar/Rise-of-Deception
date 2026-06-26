class_name RoomManager
extends Node2D

var _cam_last_room: Vector2i = Vector2i.ZERO

func _ready() -> void:
	SignalBus.disable_room.connect(disable_room)
	SignalBus.enable_room.connect(enable_room)
	SignalBus.player_travel_to_room.connect(_player_travel_to_room)
	SignalBus.transition_mid_way.connect(_transition_mid_way)

func disable_room(_room_pos: Vector2i) -> void:
	var _room_scene = Global.get_room(_room_pos)
	_room_scene.process_mode = Node.PROCESS_MODE_DISABLED

func enable_room(_room_pos: Vector2i, transition: Utils.pixel_transition_types = Utils.pixel_transition_types.NONE, transition_dir: Vector2 = Vector2i.ZERO) -> void:
	var _room_scene = Global.get_room(_room_pos)
	_room_scene.process_mode = Node.PROCESS_MODE_INHERIT
	
	if Global.current_multiplayer_status == Utils.multiplayer_status.SINGLEPLAYER:
		if transition != Utils.pixel_transition_types.NONE:
			_cam_last_room = _room_pos
			SignalBus.start_transition.emit(Utils.pixel_transition_types.ARROW, transition_dir)
		else:
			setup_room_camera(_room_pos)

func setup_room_camera(_room_pos: Vector2i) -> void:
	var _room_scene = Global.get_room(_room_pos)
	print("HOW THE FUCK")
	_room_scene.setup_camera()

func _transition_mid_way() -> void:
	setup_room_camera(_cam_last_room)

func free_rooms() -> void:
	for _child in get_children():
		if _child is RoomScene:
			_child.queue_free()

func _player_travel_to_room(_pos: Vector2, _room_pos: Vector2i, _old_room_cell_pos: Vector2i, _passage: RoomPassage) -> void:
	disable_room(_old_room_cell_pos)
	var _dir = Vector2(RoomPassage.path_direction_vector2i[_passage.direction])
	_dir.x *= -1
	enable_room(_room_pos, Utils.pixel_transition_types.ARROW, _dir)
