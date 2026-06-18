class_name ItemData
extends Resource

@export var name: StringName
@export var description: String

@export var icon_texture: Texture
@export var item_packed_scene: PackedScene

func Setup(_name: StringName, _description: String, _icon_texture: Texture, _item_packed_scene: PackedScene) -> void:
	name = _name
	description = _description
	icon_texture = _icon_texture
	item_packed_scene = _item_packed_scene
