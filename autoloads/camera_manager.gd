extends Node

var camearas: Dictionary[Player, Camera2D]

func _ready() -> void:
	SignalBus.player_passed_to_room.connect(_player_passed_to_room)

func _player_passed_to_room(_old_map_position: Vector2i, _new_map_position: Vector2i, _player: Player) -> void:
	var _camera = camearas[_player]
	var _room = Global.get_room(_new_map_position)
	_camera = _room.camera
	
	_camera.global_position = _player.global_position
