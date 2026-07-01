extends Node

var current_multiplayer_status: Utils.multiplayer_status = Utils.multiplayer_status.SINGLEPLAYER
var single_player_player: Player

var external_camera: ExternalCamera:
	set(value):
		external_camera_updated.emit(value)
		external_camera = value
var internal_camera: LocalCamera:
	set(value):
		internal_camera_updated.emit(value)
		internal_camera = value
signal external_camera_updated
signal internal_camera_updated

#region Map
var current_map: MapState

func get_room(_room: Vector2i) -> RoomScene:
	if current_map and current_map.rooms.has(_room):
		return Global.current_map.rooms[_room].room_reference
	else:
		return null
#endregion

#region Rooms

enum Room_Types {
	BASE_ROOM
}

const room_paths: Dictionary[Room_Types, PackedScene] = {
	Room_Types.BASE_ROOM: preload("uid://csy1pyeuajw0y")
}

#endregion

#region Worlds

enum Worlds {
	WORLD1, 
	WORLD2
}

const world_maps: Dictionary[Worlds, Dictionary] = {
	# TEST WORLD 1
	Worlds.WORLD1: {
		"normal": [
			Room_Types.BASE_ROOM
		],
		"special": [
			Room_Types.BASE_ROOM
		]
	},
	
	# TEST WORLD 2
	Worlds.WORLD2: {
		"normal": [
			Room_Types.BASE_ROOM
		],
		"special": [
			Room_Types.BASE_ROOM
		]
	},
	
}

func get_world_map(_world: Worlds) -> Dictionary[String, Dictionary]:
	var _dict: Dictionary[String, Dictionary]
	for _key in world_maps[_world]:
		_dict[_key] = {}
		for _room in world_maps[_world][_key]:
			var _path = room_paths[_room]
			_dict[_key][_room] = _path
	
	return _dict

#endregion
