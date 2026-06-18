class_name BaseItem
extends Node2D

var item_data: ItemData

func Create(_item_data: ItemData) -> void:
	item_data = _item_data

func Update() -> void:
	pass

func PhysicsUpdate() -> void:
	pass

func Destroy() -> void:
	queue_free()
