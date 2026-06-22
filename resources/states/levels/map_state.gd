class_name MapState
extends Resource

@export var rooms: Dictionary[Vector2i, RoomState] = {}

func add_room(_cell_pos: Vector2i) -> void:
	if !rooms.has(_cell_pos):
		var _room := RoomState.new()
		rooms[_cell_pos] = _room
		_room.Setup(_cell_pos, rooms)

func remove_room(_cell_pos: Vector2i) -> void:
	if rooms.has(_cell_pos):
		rooms[_cell_pos].Remove(rooms)
		rooms.erase(_cell_pos)
