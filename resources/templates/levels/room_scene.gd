class_name RoomScene
extends Node2D

@export_subgroup("Nodes")
@export var persistent_id: PersistentID

@export var passages: Dictionary[RoomPassage.path_direction, RoomPassage]

@export var world_boundries: WorldBoundries

@export var camera: Camera2D

@export_subgroup("Settings")
@export var room_type: Global.Room_Types
@export var player_spawn_location: Vector2 

var room_data: RoomState

signal passage_player_entered

var map_location: Vector2

signal game_saving(map_id: StringName)
signal game_loading(map_id: StringName)

func _ready() -> void:
	DataManager.game_saving.connect(_save_game)
	DataManager.game_loading.connect(_load_game)
	
	for _child in get_tree().get_nodes_in_group("Saveable"):
		if _child.has_method("setup_data_manager"):
			_child.setup_data_manager(self)
	
	for _passage_dir in passages.keys():
		var _passage = passages[_passage_dir]
		if _passage:
			if _passage.direction == _passage_dir:
				pass
			else:
				push_error("Incorrect passage direction: ",_passage_dir)
		else:
			push_error("No passage set: ",_passage_dir)

func setup_passages(left_open: bool, right_open: bool, top_open: bool, bottom_open: bool) -> void:
	passages[RoomPassage.path_direction.LEFT].open = left_open
	passages[RoomPassage.path_direction.RIGHT].open = right_open
	passages[RoomPassage.path_direction.TOP].open = top_open
	passages[RoomPassage.path_direction.BOTTOM].open = bottom_open

# ==================
# SAVING AND LOADING
# ==================

func _save_game() -> void:
	if room_data:
		game_saving.emit(room_data)

func _load_game() -> void:
	game_loading.emit(room_data)
