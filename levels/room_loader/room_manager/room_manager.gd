class_name RoomManager
extends Node2D

func disable_room(_room: Vector2i) -> void:
	var _room_scene = Global.get_room(_room)
	_room_scene.process_mode = Node.PROCESS_MODE_DISABLED

func enable_room(_room: Vector2i) -> void:
	var _room_scene = Global.get_room(_room)
	_room_scene.process_mode = Node.PROCESS_MODE_INHERIT

func free_rooms() -> void:
	for _child in get_children():
		if _child is RoomScene:
			_child.queue_free()
