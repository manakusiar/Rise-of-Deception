class_name MapTemplate
extends Resource

static func Get_Value(_is_special: bool, _amount_of_neighbours: int) -> int:
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

static func Map_To_Grid(map: MapState) -> Array[Array]:
	var _min: Vector2i = Vector2i.ZERO
	var _max: Vector2i = Vector2i.ZERO
	var rooms = map.rooms
	
	for _pos in rooms:
		_min = _pos.min(_min)
		_max = _pos.max(_max)
	
	var _size = abs(_min - _max) + Vector2i(2, 2)
	var _grid: Array[Array] = []
	for _x in _size.x:
		_grid.append([])
		for _y in _size.y:
			var _cell = Vector2i(_x + _min.x, _y + _min.y)
			if rooms.has(_cell):
				_grid[_x].append(rooms[_cell]) 
			else:
				_grid[_x].append(null)
	
	return _grid

static func Get_Neighbour_Amount(map: MapState, _cell_pos: Vector2i) -> int:
	var _neighbours: int = 0
	
	for _pos in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
		var _real_pos = _cell_pos + _pos
		if map.rooms.has(_real_pos):
			_neighbours += 1
	
	return _neighbours
