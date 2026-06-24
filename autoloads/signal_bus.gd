extends Node

signal player_entered_passage(_player: Player, _passage: RoomPassage)
signal player_travel_to_room(_new_position: Vector2, _room_cell_pos: Vector2i)

signal disable_room(_room: RoomScene)
signal enable_room(_room: RoomScene)

signal player_created(_player: Player)

signal external_camera_property_change(properties: Dictionary[StringName, Variant])
