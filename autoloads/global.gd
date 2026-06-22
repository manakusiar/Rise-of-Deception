extends Node

enum Worlds {
	WORLD1, 
	WORLD2
}

enum Room_Types {
	BASE_ROOM
}

const room_paths: Dictionary[Room_Types, PackedScene] = {
	Room_Types.BASE_ROOM: preload("uid://csy1pyeuajw0y")
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
		
