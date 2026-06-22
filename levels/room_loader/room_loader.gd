class_name MapManager
extends Node2D

@export var room_manager: RoomManager
@export var player_manager: PlayerManager
@export var external_camera: Camera2D

var current_map: MapState

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

func _save_game() -> void:
	DataManager.master_data.map_data = current_map

func _load_game() -> void:
	Load_Map(DataManager.master_data.map_data)

func Load_Map(_map: MapState = current_map) -> void:
	current_map = _map
	
	var _x := 0.0
	var _map_dict = _map.rooms
	
	room_manager.free_rooms()
	
	for _room_pos in _map_dict:
		var _room: RoomState = _map_dict[_room_pos]
		var _preload = Global.room_paths[_room.type]
		if _preload.can_instantiate():
			print("LOADED ROOM")
			# Create room
			var _room_loaded = _preload.instantiate()
			room_manager.add_child(_room_loaded)
			
			# Setup room
			_room_loaded.position.x += _x
			
			# Map to room
			_room_loaded.setup_passages(
				_map_dict.has(_room_pos + Vector2i(-1, 0)),
				_map_dict.has(_room_pos + Vector2i(1, 0)),
				_map_dict.has(_room_pos + Vector2i(0, 1)),
				_map_dict.has(_room_pos + Vector2i(0, -1))
			)
			
			_room_loaded.map_location = _room_pos
			_room_loaded.room_data = _room
			
			_room_loaded.process_mode = Node.PROCESS_MODE_DISABLED
			
			# Room to map
			_room.room_unique_id = _room_loaded.persistent_id.unique_id
			
			# Finish up
			var _boundries: WorldBoundries = _room_loaded.world_boundries
			_x += _boundries.size.x + _boundries.border_depth * 2
