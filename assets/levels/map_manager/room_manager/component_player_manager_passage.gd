class_name ComponentPlayerManagerPassage
extends Node

func _ready() -> void:
	SignalBus.player_entered_passage.connect(_player_entered_passage)

func _player_entered_passage(_player, _passage) -> void:
	var _room: RoomScene = _passage.room
	
	if _room:
		var _cell_pos = _room.map_location
		var _dir = RoomPassage.path_direction_vector2i[_passage.direction]
		var _next_cell_pos = _cell_pos + _dir
		
		var _all_rooms = Global.current_map.rooms
		if _all_rooms.has(_next_cell_pos):
			var _next_room_scene: RoomScene = _all_rooms[_next_cell_pos].room_reference
			if _next_room_scene:
				var _new_dir: RoomPassage.path_direction = RoomPassage.path_direction_opposites[_passage.direction]
				var _new_passages = _next_room_scene.passages
				if _new_passages.has(_new_dir):
					var _new_passage = _new_passages[_new_dir]
					var _new_pos = _next_room_scene.position + _new_passage.player_tp_position
					SignalBus.player_travel_to_room.emit(_new_pos, _next_cell_pos, _cell_pos, _new_passage)
				else:
					push_error("Error: Player travel room passage is not set: ", _next_room_scene)
			else:
				push_error("Error: Player travel room scene reference does not exist or is not set")
		else:
			push_error("Error: Trying to travel the player outside of the map.")
