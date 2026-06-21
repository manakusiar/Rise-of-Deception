extends Node2D

@export var loaded_rooms: Node2D
@export var external_camera: Camera2D

var current_map: Map

func _ready() -> void:
	generate_map()

func generate_map() -> void:
	if !current_map:
		current_map = Map.new()
	
	current_map.regenerate_map(16, Global.normal_maps, Global.special_maps)
