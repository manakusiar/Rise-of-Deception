class_name Map
extends Node2D

@export var persistent_id: PersistentID

signal game_saving(map_id: StringName)
signal game_loading(map_id: StringName)

func _ready() -> void:
	DataManager.game_saving.connect(_save_game)
	DataManager.game_loading.connect(_load_game)
	
	for _child in get_tree().get_nodes_in_group("Saveable"):
		if _child.has_method("setup_data_manager"):
			_child.setup_data_manager(self)

func _save_game() -> void:
	var _room_data = DataManager.master_data.room_data
	if !_room_data.has(StringName(persistent_id.unique_id)):
		_room_data[StringName(persistent_id.unique_id)] = RoomData.new()
	
	game_saving.emit(persistent_id.unique_id)

func _load_game() -> void:
	game_loading.emit(persistent_id.unique_id)
