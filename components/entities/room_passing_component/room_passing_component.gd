class_name RoomPassingComponent
extends Node

@export var player: Player

@export var map_position := Vector2i.ZERO

var cooldown: Timer

func _ready() -> void:
	SignalBus.passage_player_entered.connect(_player_entered_passage)
	
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.one_shot = true
	cooldown.wait_time = 1.0

func _player_entered_passage(_passage: RoomPassage, _player: Player) -> void:
	print("CHECKED PLAYER ", player.name, "FOR TP")
	if cooldown.is_stopped() and _player == player:
		print("IS PLAYER!!!")
		Change_Map_Position(
			map_position + RoomPassage.path_direction_vector2i[_passage.direction],
			RoomPassage.path_direction_opposites[_passage.direction]
		)

func Get_Save_Data() -> Dictionary:
	return {
		&"map_position": map_position,
		&"local_position": player.global_position - Get_Local_Room().global_position
	}

func Load_Save_Data(data: Dictionary) -> void:
	print("PHYSICS LOADING: ", data)
	map_position = data[&"map_position"]
	Player_To_Local_Position(data[&"local_position"])
	

func Player_To_Local_Position(_local_pos: Vector2) -> void:
	player.global_position = _local_pos + Get_Local_Room().position

func Get_Local_Room() -> RoomScene:
	return Global.current_map.rooms[map_position].room_reference

func Change_Map_Position(_new_map_position, _entrence_direction) -> void:
	var _room: RoomScene = Global.current_map.rooms[_new_map_position].room_reference
	if _room and player:
		cooldown.start()
		
		var _old_map_position = map_position
		map_position = _new_map_position
		
		var _tp_position = _room.passages[_entrence_direction].player_tp_position
		player.global_position = _tp_position + _room.global_position
		
		var _properties = _room.passages[_entrence_direction].player_tp_properties
		for _property_name in _properties:
			if _property_name in player:
				player.set(_property_name, _properties[_property_name])
		
		SignalBus.player_passed_to_room.emit(_old_map_position, _new_map_position, player)
