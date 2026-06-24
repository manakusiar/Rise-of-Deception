class_name MapManager
extends Node2D

@export var room_manager: RoomManager
@export var player_manager: PlayerManager

var current_map: MapState:
	get():
		return Global.current_map
	set(value):
		Global.current_map = value

func _ready() -> void:
	DataManager.game_saving.connect(_save_game)
	DataManager.game_loading.connect(_load_game)
	
	generate_map(Global.Worlds.WORLD1)

func generate_map(_world: Global.Worlds) -> void:
	if !current_map:
		current_map = MapState.new()
	
	var _world_data = Global.get_world_map(_world)
	MapGenerator.regenerate_map(current_map, 16, _world_data["normal"], _world_data["special"])
	
	Load_Map()

#region Save / Load
func _save_game() -> void:
	DataManager.master_data.map_data = current_map

func _load_game() -> void:
	Load_Map(DataManager.master_data.map_data)

func Load_Map(_map: MapState = current_map) -> void:
#endregion
	current_map = _map
	
	var _x := 0.0
	var _map_dict = _map.rooms
	
	room_manager.free_rooms()
	
	for _room_pos in _map_dict:
		var _room: RoomState = _map_dict[_room_pos]
		
		# Create room
		var _room_state = instantiate_room_state(_room, _map_dict, _room_pos)
		_room_state.position.x += _x
		
		# Finish up
		var _boundries: WorldBoundries = _room_state.world_boundries
		_x += _boundries.size.x + _boundries.border_depth + get_viewport_rect().size.x

func instantiate_room_state(_room: RoomState, _map_dict, _room_pos: Vector2i) -> RoomScene:
	var _preload = Global.room_paths[_room.type]
	if _preload.can_instantiate():
		var _room_state: RoomScene = _preload.instantiate()
		room_manager.add_child(_room_state)
		
		# Map to room
		_room_state.setup_passages(
			_map_dict.has(_room_pos + RoomPassage.path_direction_vector2i[RoomPassage.path_direction.LEFT]),
			_map_dict.has(_room_pos + RoomPassage.path_direction_vector2i[RoomPassage.path_direction.RIGHT]),
			_map_dict.has(_room_pos + RoomPassage.path_direction_vector2i[RoomPassage.path_direction.TOP]),
			_map_dict.has(_room_pos + RoomPassage.path_direction_vector2i[RoomPassage.path_direction.BOTTOM])
		)
		
		_room_state.map_location = _room_pos
		_room_state.room_data = _room
		
		#_room_state.process_mode = Node.PROCESS_MODE_DISABLED
		
		# Room to map
		_room.room_unique_id = _room_state.persistent_id.unique_id
		_room.room_reference = _room_state
		
		return _room_state
	
	return null
		
