class_name PlayerManager
extends Node2D

@export var map_manager: MapManager

@export var players_by_room_pos: Dictionary[Vector2i, Array]
@export var players_by_id: Dictionary[StringName, Player]

const player_packedscene = preload("uid://ciw3lcn0jn2iy")

func _ready() -> void:
	SignalBus.player_entered_passage.connect(_player_entered_passage)
	add_player.call_deferred()

func add_player():
	var is_singleplayer = Global.current_multiplayer_status == Utils.multiplayer_status.SINGLEPLAYER and get_children().size() <= 0
	var not_singleplayer = Global.current_multiplayer_status == Utils.multiplayer_status.SINGLEPLAYER
	if is_singleplayer or not_singleplayer:
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
		
		if is_singleplayer:
			Global.single_player_player = _player

func _player_entered_passage(_player: Player, _passage: RoomPassage) -> void:
	pass
