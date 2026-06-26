class_name ComponentPlayerPassage
extends Node

@export var player: Player
@export var area: Area2D

@export var map_position := Vector2i.ZERO

var cooldown: Timer

func _ready() -> void:
	area.area_entered.connect(_detected_path)
	SignalBus.player_travel_to_room.connect(_moved_through_movement_passage)
	
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.one_shot = true
	cooldown.wait_time = 0.1

#region Save / Load
func Get_Save_Data() -> Dictionary:
	return {
		&"global_position": player.global_position,
		&"map_position": map_position
	}

func Load_Save_Data(data: Dictionary) -> void:
	_travel_to_room(
		data[&"global_position"],
		data[&"map_position"]
	)
#endregion

func _detected_path(area: Area2D) -> void:
	if area.is_in_group(&"passage") and cooldown.is_stopped():
		SignalBus.player_entered_passage.emit(self, area.owner)

func _moved_through_movement_passage(_new_position: Vector2i, _room_cell_pos: Vector2i, _old_room_cell: Vector2i, _passage: RoomPassage) -> void:
	_apply_passage_properties(_passage)
	_travel_to_room(_new_position, _room_cell_pos)

func _travel_to_room(_new_position: Vector2i, _room_cell_pos: Vector2i, _old_room_cell: Vector2i = Vector2i.ZERO) -> void:
	if cooldown.is_stopped():
		map_position = _room_cell_pos
		player.global_position = _new_position
		
		cooldown.start()

func _apply_passage_properties(_passage: RoomPassage) -> void:
	var _properties: Dictionary[StringName, Variant] = _passage.player_tp_properties
	var _buffs: Array[StatBuff] = _passage.player_tp_buffs
	
	if _properties:
		for _property_name in _properties:
			if _property_name in player:
				player.set.call_deferred(_property_name, _properties[_property_name])
	
	if _buffs:
		var _player_stats = player.stats
		for _buff in _buffs:
			_player_stats.add_buff(_buff)
