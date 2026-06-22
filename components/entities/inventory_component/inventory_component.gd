extends Node
class_name InventoryComponent

var item_node_group: Node2D
@export var inventory: Dictionary[Utils.ItemID, ItemData]
@export var entity: Node

func _ready() -> void:
	load_item_node_group()

func Get_Save_Data() -> Dictionary:
	return inventory

func Load_Save_Data(data: Dictionary[Utils.ItemID, ItemData]) -> void:
	inventory = data

func load_item_node_group() -> void:
	item_node_group = Node2D.new()
	entity.add_child.call_deferred(item_node_group)
	
	reload_all_items()

func reload_all_items() -> void:
	for _key in inventory:
		var _item_packed = inventory[_key].item_packed_scene
		if _item_packed.can_instantiate():
			var _item_node: BaseItem = _item_packed.instantiate()
			item_node_group.add_child(_item_node)
			
			_item_node.Create(inventory[_key], entity)

func Add_Item(_item_id: Utils.ItemID):
	pass

func _process(delta: float) -> void:
	var _item_nodes = item_node_group.get_children()
	for _item_node in _item_nodes:
		if _item_node is BaseItem:
			_item_node.Update(delta)

func _physics_process(delta: float) -> void:
	var _item_nodes = item_node_group.get_children()
	for _item_node in _item_nodes:
		if _item_node is BaseItem:
			_item_node.PhysicsUpdate(delta)
