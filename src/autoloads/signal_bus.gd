extends Node

signal player_entered_passage(_player: Player, _passage: RoomPassage)
signal player_travel_to_room(_new_position: Vector2, _room_cell_pos: Vector2i, _old_room_cell_pos: Vector2i, _passage: RoomPassage)

signal map_generation_finished
signal disable_room(_room: RoomScene)
signal enable_room(_room: RoomScene)

signal player_created(_player: Player, _room_pos: Vector2i)

signal external_camera_property_change(properties: Dictionary[StringName, Variant])

signal transition_mid_way
signal transition_ended

signal start_transition(_transition: Utils.pixel_transition_types, direction: Vector2)
