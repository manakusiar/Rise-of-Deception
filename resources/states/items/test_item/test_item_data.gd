extends ItemData
class_name TestItemData

func _init() -> void:
	var _name: StringName = &"Test Item"
	var _description: String = "This is a TEST item."
	var _icon_texture: Texture
	var _item_packed_scene: PackedScene = preload("uid://l2nte72qxh6t")
	Setup(_name, _description, _icon_texture, _item_packed_scene)
