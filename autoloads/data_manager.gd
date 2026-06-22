extends Node

signal game_saving
signal game_loading

var master_data: MasterData

# ===============
# ENGINE CALLBACK
# ===============

func _ready() -> void:
	master_data = MasterData.new()

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
	
	ResourceSaver.save(master_data, "user://test_save_slot.tres")

func load_game() -> void:
	master_data = ResourceLoader.load("user://test_save_slot.tres")
	
	game_loading.emit()
