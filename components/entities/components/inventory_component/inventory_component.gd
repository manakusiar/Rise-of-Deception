extends Node
class_name InventoryComponent

var item_node_group: Node2D
@export var inventory: Dictionary[Utils.ItemID, ItemData]

func Add_Item(_item_id: Utils.ItemID):
	pass

func _process(delta: float) -> void:
	var _item_nodes = item_node_group.get_children()
	for _item_node in _item_nodes:
		if _item_node is BaseItem:
			_item_node.Update()

func _physics_process(delta: float) -> void:
	var _item_nodes = item_node_group.get_children()
	for _item_node in _item_nodes:
		if _item_node is BaseItem:
			_item_node.PhysicsUpdate()
