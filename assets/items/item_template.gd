class_name BaseItem
extends Node2D

var item_data: DataItem
var entity: Node

func Create(_item_data: DataItem, _entity: Node) -> void:
	item_data = _item_data
	entity = _entity
	
	on_create()

func on_create() -> void:
	pass

func Update(delta: float) -> void:
	pass

func PhysicsUpdate(delta: float) -> void:
	pass

func Destroy() -> void:
	on_destroy()
	
	queue_free()

func on_destroy() -> void:
	pass
