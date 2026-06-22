class_name RoomState
extends Resource

# Core variables
@export var neighbours: Array[Vector2i]
@export var empty_neighbours: Array[Vector2i]

@export var cell_pos: Vector2i
@export var room_unique_id: StringName

@export var type: Global.Room_Types

# Dynamic variables 
var value: int = 0
var is_special: bool = false

@export var data: Dictionary[StringName, DataTemplate]

# =====
# SETUP
# =====

func Setup(_cell_pos, _map: Dictionary[Vector2i, RoomState]) -> void:
	cell_pos = _cell_pos
	
	Update_Neighbours(_map)

# =============================
# UPDATES, CREATION AND REMOVAL
# =============================

func Update_Neighbours(_map: Dictionary[Vector2i, RoomState]) -> void:
	neighbours = []
	empty_neighbours = []
	
	for _pos in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
		var _real_pos = cell_pos + _pos
		if _map.has(_real_pos):
			neighbours.append(_real_pos)
			if !_map[_real_pos].neighbours.has(cell_pos):
				_map[_real_pos].neighbours.append(cell_pos)
		else:
			empty_neighbours.append(_real_pos)

func Remove(_map: Dictionary[Vector2i, RoomState]) -> void:
	for _pos in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
		var _real_pos = cell_pos + _pos
		if _map.has(_real_pos):
			if _map[_real_pos].neighbours.has(cell_pos):
				_map[_real_pos].neighbours.erase(cell_pos)
				_map[_real_pos].empty_neighbours.append(cell_pos)
