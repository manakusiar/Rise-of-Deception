class_name Map
extends Resource

var map: Dictionary[Vector2i, MapRoom] = {}

# =======
# CLASSES
# =======

class MapRoom:
	var neighbours: Array[Vector2i]
	var empty_neighbours: Array[Vector2i]
	var cell_pos: Vector2i
	
	var value: int = 0
	var is_special: bool = false
	
	func _init(_cell_pos, _map: Dictionary[Vector2i, MapRoom]) -> void:
		cell_pos = _cell_pos
		
		Update_Neighbours(_map)
	
	func Update_Neighbours(_map: Dictionary[Vector2i, MapRoom]) -> void:
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
	
	func Get_Value(_is_special: bool) -> int:
		is_special = _is_special
		value = 0
		
		if is_special:
			match neighbours.size():
				0:
					value += -100
				1:
					value += 40
				2: 
					value += 10
				4: 
					value -= 10
		else:
			match neighbours.size():
				0:
					value += -100
				1:
					value -= 10
				2: 
					value += 40
				4: 
					value -= 10
		
		return value
	
	func Remove_Cell(_map: Dictionary[Vector2i, MapRoom]) -> void:
		for _pos in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
			var _real_pos = cell_pos + _pos
			if _map.has(_real_pos):
				if _map[_real_pos].neighbours.has(cell_pos):
					_map[_real_pos].neighbours.erase(cell_pos)
					_map[_real_pos].empty_neighbours.append(cell_pos)
					

# =========
# FUNCTIONS
# =========

func regenerate_map(_map_size: int, _normal_rooms: Dictionary[StringName, PackedScene], _special_rooms: Dictionary[StringName, PackedScene]) -> void:
	
	map.clear()
	
	add_cell(Vector2i(0, 0))
	
	
	# Normal rooms
	for i in range(_map_size - 1):
		generate_rooms(false)
	
	for i in range(_special_rooms.size()):
		generate_rooms(true)
	
	Print_Grid()

func generate_rooms(are_special: bool = false) -> void:
	var _concideration_rooms: Dictionary[int, Array]
	
	for _pos in map:
		var _room = map[_pos]
		
		for _neighbour in _room.empty_neighbours:
			if !map.has(_neighbour):
				var _value = Get_Value(are_special, Get_Neighbour_Amount(_neighbour))
				if !_concideration_rooms.has(_value):
					_concideration_rooms[_value] = []
				_concideration_rooms[_value].append(_neighbour)
		
	var _array = concider_by_value(_concideration_rooms)
	var _winner_num = randi() % min(map.size()/2 + 1, _array.size())
	var _win_pos = _array[_winner_num]
	
	add_cell(_win_pos)
	map[_win_pos].is_special = are_special

func To_Grid() -> Array[Array]:
	var _min: Vector2i = Vector2i.ZERO
	var _max: Vector2i = Vector2i.ZERO
	
	for _pos in map:
		_min = _pos.min(_min)
		_max = _pos.max(_max)
	
	var _size = abs(_min - _max) + Vector2i(2, 2)
	var _grid: Array[Array] = []
	for _x in _size.x:
		_grid.append([])
		for _y in _size.y:
			var _cell = Vector2i(_x + _min.x, _y + _min.y)
			if map.has(_cell):
				_grid[_x].append(map[_cell]) 
			else:
				_grid[_x].append(null)
	
	return _grid

func Print_Grid() -> void:
	var _grid = To_Grid()
	var _size = Vector2i(_grid.size(), len(_grid[0]))
	var _title = "GRID"
	var _len = ((_size.y * 2 + 2) - _title.length())/ 2
	print('='.repeat(floori(_len)), _title, '='.repeat(ceili(_len)))
	for _x in range(_size.x):
		var _text = "|"
		for _y in range(_size.y):
			var _cell = _grid[_x][_y]
			if _cell != null and _cell is MapRoom:
				if _cell.cell_pos == Vector2i(0, 0):
					_text += "o"
				else:
					if _cell.is_special:
						_text += "s"
					else:
						_text += "x"
			else:
				_text += "-"
			_text += " "
		print(_text, "|")

func concider_by_value(dict: Dictionary[int, Array]) -> Array:
	var _keys = dict.keys()
	_keys.sort()
	_keys.reverse()
	
	var _array = []
	for _key in _keys:
		var _value: Array = dict[_key]
		for i in _value:
			_array.append(i)
	
	return _array

func Get_Value(_is_special: bool, _amount_of_neighbours: int) -> int:
		var value = 0
		
		if _is_special:
			match _amount_of_neighbours:
				0:
					value += -100
				1:
					value += 40
				2: 
					value += 10
				4: 
					value -= 10
		else:
			match _amount_of_neighbours:
				0:
					value += -100
				1:
					value -= 10
				2: 
					value += 40
				4: 
					value -= 10
		
		return value

func Get_Neighbour_Amount(_cell_pos) -> int:
	var _neighbours: int = 0
	
	for _pos in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
		var _real_pos = _cell_pos + _pos
		if map.has(_real_pos):
			_neighbours += 1
	
	return _neighbours

func add_cell(_cell_pos: Vector2i) -> void:
	if !map.has(_cell_pos):
		map[_cell_pos] = MapRoom.new(_cell_pos, map)

func remove_cell(_cell_pos: Vector2i) -> void:
	map[_cell_pos].Remove_Cell(map)
	map.erase(_cell_pos)
