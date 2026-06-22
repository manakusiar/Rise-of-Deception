class_name RoomManager
extends Node2D

func disable_room(_room: Vector2i) -> void:
	pass

func free_rooms() -> void:
	for _child in get_children():
		if _child is RoomScene:
			_child.queue_free()
