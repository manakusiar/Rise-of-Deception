extends Node

signal passage_player_entered
signal player_passed_to_room(_old_map_position: Vector2i, _new_map_position: Vector2i, _player: Player)

signal disable_room(_room: RoomScene)
signal enable_room(_room: RoomScene)

signal player_created(_player: Player)

signal external_camera_property_change(properties: Dictionary[StringName, Variant])
