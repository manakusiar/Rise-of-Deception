class_name BaseMap
extends Node2D

@export var persistent_id: PersistentID

@export var passage_left: RoomPassage
@export var passage_right: RoomPassage
@export var passage_top: RoomPassage
@export var passage_bottom: RoomPassage

@export var world_boundries: WorldBoundries

signal game_saving(map_id: StringName)
signal game_loading(map_id: StringName)

func _ready() -> void:
	DataManager.game_saving.connect(_save_game)
	DataManager.game_loading.connect(_load_game)
	
	for _child in get_tree().get_nodes_in_group("Saveable"):
		if _child.has_method("setup_data_manager"):
			_child.setup_data_manager(self)
	
	# Various checks
	if passage_left and passage_right and passage_top and passage_bottom:
		var _left_test := (passage_left.direction == RoomPassage.path_direction.LEFT)
		var _right_test := (passage_right.direction == RoomPassage.path_direction.RIGHT)
		var _top_test := (passage_top.direction == RoomPassage.path_direction.TOP)
		var _bottom_test := (passage_bottom.direction == RoomPassage.path_direction.BOTTOM)
		if _left_test and _right_test and _top_test and _bottom_test:
			print("ROOM \"", str(name).to_upper(), "\" LOADED!")
		else:
			push_error("Error: Either correct incorrectly setup map passage or map passage reference not set.")
	else:
		push_error("Error: Map passage reference not set.")

func _save_game() -> void:
	var _room_data = DataManager.master_data.room_data
	if !_room_data.has(StringName(persistent_id.unique_id)):
		_room_data[StringName(persistent_id.unique_id)] = RoomData.new()
	
	game_saving.emit(persistent_id.unique_id)

func _load_game() -> void:
	game_loading.emit(persistent_id.unique_id)
