class_name RoomPassingComponent
extends Node

@export var player: Player
@export var area: Area2D

@export var map_position := Vector2i.ZERO

var cooldown: Timer

func _ready() -> void:
	area.area_entered.connect(_detected_path)
	
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
	print("Detected area %d" % area.name)
	if area.is_in_group(&"passage"):
		
		SignalBus.player_entered_passage.emit(self, area)

func _travel_to_room(_new_position: Vector2i, _room_cell_pos: Vector2i) -> void:
	map_position = _room_cell_pos
	player.global_position = _new_position
	
	cooldown.start()
