extends Node

signal game_saving
signal game_loading

var data_master: DataMaster

# ===============
# ENGINE CALLBACK
# ===============

func _ready() -> void:
	data_master = DataMaster.new()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_save_game"):
		save_game()
		print("SAVE GAME")
	if event.is_action_pressed("test_load_game"):
		load_game()
		print("LOADED GAME")

# =================
# PRIMARY FUNCTIONS
# =================

func save_game() -> void:
	game_saving.emit()
	
	ResourceSaver.save(data_master, "user://test_save_slot.tres")

func load_game() -> void:
	data_master = ResourceLoader.load("user://test_save_slot.tres")
	
	game_loading.emit()
