@tool
extends Node

@export_subgroup("Nodes")
@export var left_boundry: CollisionShape2D
@export var right_boundry: CollisionShape2D
@export var top_boundry: CollisionShape2D
@export var bottom_boundry: CollisionShape2D

@export_subgroup("Values")
@export var border_depth := 16.0:
	set(value):
		border_depth = value
		reload_size()

@export var size: Vector2 = Vector2(0.0, 0.0):
	set(value):
		size = value
		reload_size()


func reload_size() -> void:
	var _side_size = size + Vector2(0, 2 * border_depth)
	if left_boundry:
		left_boundry.scale = Vector2(border_depth,_side_size.y) / border_depth
		left_boundry.position = Vector2(-border_depth/2, _side_size.y / 2 - border_depth)
	if right_boundry:
		right_boundry.scale = Vector2(border_depth,_side_size.y) / border_depth
		right_boundry.position = Vector2(size.x + border_depth/2, _side_size.y / 2 - border_depth)
	if top_boundry:
		top_boundry.scale = Vector2(size.x, border_depth) / border_depth
		top_boundry.position = Vector2(size.x / 2, -border_depth/2)
	if bottom_boundry:
		bottom_boundry.scale = Vector2(size.x, border_depth) / border_depth
		bottom_boundry.position = Vector2(size.x / 2, size.y + border_depth/2)
	
	if owner == self:
		left_boundry.shape.size = Vector2(border_depth, border_depth)
		right_boundry.shape.size = Vector2(border_depth, border_depth)
		top_boundry.shape.size = Vector2(border_depth, border_depth)
		bottom_boundry.shape.size = Vector2(border_depth, border_depth)
