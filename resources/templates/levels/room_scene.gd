class_name RoomScene
extends Node2D

@export_subgroup("Nodes")
@export var persistent_id: PersistentID

@export var passage_left: RoomPassage
@export var passage_right: RoomPassage
@export var passage_top: RoomPassage
@export var passage_bottom: RoomPassage

@export var world_boundries: WorldBoundries

@export_subgroup("Settings")
@export var room_type: Global.Room_Types

var room_data: RoomState

signal game_saving(map_id: StringName)
signal game_loading(map_id: StringName)

var map_location: Vector2:
	set(value):
		map_location = value
		%Label.text = str(value)

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
			#print("ROOM \"", str(name).to_upper(), "\" LOADED!")
			pass
		else:
			push_error("Error: Either correct incorrectly setup map passage or map passage reference not set.")
	else:
		push_error("Error: Map passage reference not set.")

func setup_passages(left_open: bool, right_open: bool, top_open: bool, bottom_open: bool) -> void:
	passage_left.open = left_open
	passage_right.open = right_open
	passage_top.open = top_open
	passage_bottom.open = bottom_open

# ==================
# SAVING AND LOADING
# ==================

func _save_game() -> void:
	if room_data:
		game_saving.emit(room_data)

func _load_game() -> void:
	game_loading.emit(room_data)
