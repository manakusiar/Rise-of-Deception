class_name PlayerManager
extends Node2D

@export var players_by_room_pos: Dictionary[Vector2i, Array]
@export var players_by_id: Dictionary[StringName, Player]

const player_packedscene = preload("uid://ciw3lcn0jn2iy")

func _ready() -> void:
	SignalBus.player_passed_to_room.connect(_player_passed_to_room)
	
	add_player.call_deferred()

func add_player():
	var _player: Player = player_packedscene.instantiate()
	add_child(_player)
	
	var _id := _player.persistent_id.unique_id
	var _room_pos := Vector2i(0, 0)
	_player.room_passing_component.map_position = _room_pos
	
	var _room_scene = Global.get_room(_room_pos)
	_player.position = _room_scene.global_position + _room_scene.player_spawn_location
	
	
	if !players_by_room_pos.has(_room_pos):
		players_by_room_pos[_room_pos] = []
	
	var _array := players_by_room_pos[_room_pos]
	if !_array.has(_player):
		_array.append(_player)
	
	SignalBus.player_created.emit(_player)

func _player_passed_to_room(_old_room_pos: Vector2i, _new_room_pos: Vector2i, _player: Player) -> void:
	if players_by_room_pos.has(_old_room_pos):
		var _old_room_array = players_by_room_pos[_old_room_pos]
		if _old_room_array.has(_player):
			_old_room_array.erase(_player)
			_check_room(_old_room_pos)
	else:
		push_error("Error: old room ", _old_room_pos, "has not been visited by a player yet!")
	
	if players_by_room_pos.has(_new_room_pos):
		var _new_room_array = players_by_room_pos[_new_room_pos]
		if !_new_room_array.has(_player):
			_new_room_array.append(_player)
			_check_room(_new_room_pos)
	else:
		push_error("Error: new room ", _old_room_pos, "has not been visited by a player yet!")

func _check_room(_room_pos: Vector2i) -> void:
	if players_by_room_pos.has(_room_pos):
		if players_by_room_pos[_room_pos].size() > 0:
			SignalBus.enable_room.emit(_room_pos)
		else:
			SignalBus.disable_room.emit(_room_pos)
	else:
		SignalBus.disable_room.emit(_room_pos)
