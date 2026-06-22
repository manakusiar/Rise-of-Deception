class_name MapGenerator
extends Resource

static func regenerate_map(map: MapState, map_size: int, normal_rooms: Dictionary, special_rooms: Dictionary) -> void:
	var rooms = map.rooms
	
	rooms.clear()
	
	map.add_room(Vector2i(0, 0))
	
	var room_type: Global.Room_Types
	
	# Normal rooms
	var _room_num: int = 0
	var _normal_keys = normal_rooms.keys()
	_normal_keys.shuffle()
	
	for i in range(map_size - 1):
		MapGenerator.generate_room(map, _normal_keys[_room_num], false)
		_room_num += 1
		if _room_num >= _normal_keys.size():
			_normal_keys.shuffle()
			_room_num = 0
	
	# Special rooms
	var _special_keys = special_rooms.keys()
	for i in range(special_rooms.size()):
		MapGenerator.generate_room(map, _special_keys[i], true)
	
	Print_Grid(map)

static func generate_room(map: MapState, _room_type: Global.Room_Types, are_special: bool = false) -> void:
	var rooms = map.rooms
	var _concidered_rooms: Dictionary[int, Array]
	var _checked_rooms: Array[Vector2i]
	
	for _pos in rooms:
		var _room = rooms[_pos]
		
		for _neighbour in _room.empty_neighbours:
			if !rooms.has(_neighbour) and !_neighbour in _checked_rooms:
				var _value = MapTemplate.Get_Value(are_special, MapTemplate.Get_Neighbour_Amount(map, _neighbour))
				if !_concidered_rooms.has(_value):
					_concidered_rooms[_value] = []
				
				_concidered_rooms[_value].append(_neighbour)
				_checked_rooms.append(_neighbour)
		
	var _array = _get_values_from_concideration(_concidered_rooms)
	var _winner_num = randi() % min(rooms.size()/2 + 1, _array.size())
	var _win_pos = _array[_winner_num]
	
	map.add_room(_win_pos)
	rooms[_win_pos].is_special = are_special

static func _get_values_from_concideration(dict: Dictionary[int, Array]) -> Array:
	var _keys = dict.keys()
	_keys.sort()
	_keys.reverse()
	
	var _array = []
	for _key in _keys:
		var _value: Array = dict[_key]
		for i in _value:
			_array.append(i)
	
	return _array

static func Print_Grid(map: MapState) -> void:
	var _grid = MapTemplate.Map_To_Grid(map)
	
	var _size = Vector2i(_grid.size(), len(_grid[0]))
	var _title = "GRID"
	var _len = ((_size.y * 2 + 2) - _title.length())/ 2
	
	print('='.repeat(floori(_len)), _title, '='.repeat(ceili(_len)))
	for _x in range(_size.x):
		var _text = "|"
		for _y in range(_size.y):
			var _cell = _grid[_x][_y]
			if _cell != null and _cell is RoomState:
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
